#!/usr/bin/env ruby
# frozen_string_literal: false

require 'minitest/autorun'
require_relative '../lib/toby'

# Tests that ensure no exceptions occur when instantiating a Toby::TOML::TOMLData instance
class InstantiationTests < Minitest::Test
  def instantiation_test(file_name)
    Toby::TOML::TOMLData.new(File.read("#{__dir__}/examples/#{file_name}.toml"))
  end

  def test_0_5_0_instantiation
    instantiation_test('0.5.0')
  end

  def test_example_instantiation
    instantiation_test('example')
  end

  def test_fruit_instantiation
    instantiation_test('fruit')
  end

  def test_newline_in_strings_instantiation
    instantiation_test('newline_in_strings')
  end

  def test_preserve_quotes_in_string_instantiation
    instantiation_test('preserve_quotes_in_string')
  end

  def test_hard_instantiation
    instantiation_test('hard')
  end

  def test_string_slash_whitespace_newline_instantiation
    instantiation_test('string_slash_whitespace_newline')
  end

  def test_table_names_instantiation
    instantiation_test('table_names')
  end

  def test_test_instantiation
    instantiation_test('test')
  end
end
