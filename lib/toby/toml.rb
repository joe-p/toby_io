# frozen_string_literal: true

module Toby
  class TomlTable
    attr_reader :split_keys, :name
    attr_accessor :key_values, :header_comments, :inline_comment

    def initialize(split_keys, inline_comment, is_array_table)
      @split_keys = split_keys
      @name = split_keys&.join('.')
      @inline_comment = inline_comment
      @is_array_table = is_array_table

      @header_comments = []
      @key_values = []
    end

    def is_array_table?
      @is_array_table
    end

    def to_hash
      output_hash = {}

      key_values.each do |kv|
        output_hash[kv.key] = kv.value
      end

      output_hash
    end
  end

  class TomlKeyValue
    attr_reader :key, :split_keys
    attr_accessor :value, :table, :header_comments, :inline_comment

    def initialize(split_keys, value, inline_comment)
      @split_keys = split_keys
      @key = split_keys.join('.')

      @value = value
      @header_comments = []
      @inline_comment = inline_comment
      @table = table
    end
  end

  class TOML < TomlTable
    attr_reader :tables

    def initialize(input_string)
      super(nil, '', false)

      @tables = [self]
      matches = Toby::Document.parse(input_string).matches

      @comment_buffer = []

      matches.each do |m|
        if m.respond_to? :toml_object
          toml_object_handler(m.toml_object)

        elsif m.respond_to? :stripped_comment
          @comment_buffer << m.stripped_comment

        end
      end
    end

    def toml_object_handler(obj)
      if obj.respond_to?(:header_comments) && !@comment_buffer.empty?
        obj.header_comments = @comment_buffer
        @comment_buffer = []
      end

      if obj.is_a? Toby::TomlTable
        @tables << obj

      elsif obj.is_a? Toby::TomlKeyValue
        @tables.last.key_values << obj

      end
    end

    def to_hash
      output_hash = {}

      tables.each do |tbl|
        if tbl.name.nil?
          output_hash[nil] = super

        elsif tbl.is_array_table?
          output_hash[tbl.name] ||= []
          output_hash[tbl.name] << tbl.to_hash

        else
          output_hash[tbl.name] = tbl.to_hash
        end
      end

      output_hash
    end

    def inline_comment
      nil
    end
  end
end
