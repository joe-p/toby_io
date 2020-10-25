# Represents an inline-table value
# @see https://toml.io/en/v1.0.0-rc.3#inline-table
class Toby::TOML::InlineTable < Array
    
    # @return [String] Inline table in valid TOML format
    def dump
      output = StringIO.new

      output.print '{'

      each do |kv|
        dumped_value = kv.value.respond_to?(:dump) ? kv.value.dump : kv.value

        dotted_keys = kv.split_keys.map { |key| kv.bare_key?(key) ? key : kv.quote_key(key) }.join('.')

        output.print " #{dotted_keys} = #{dumped_value},"
      end

      output.string.gsub(/,$/, ' }')
    end

    # @return [Hash] Returns the value of KeyValue#value.to_hash or simply KeyValue#value in a Hash
    def to_hash
      output_hash = {}

      each do |kv|
        output_hash[kv.key] = kv.value.respond_to?(:to_hash) ? kv.value.to_hash : kv.value
      end

      output_hash
    end
end