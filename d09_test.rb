# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'd09'

class TestD09 < Minitest::Test
  def setup
    @input = <<~INPUT
      7,1
      11,1
      11,7
      9,7
      9,5
      2,5
      2,3
      7,3
    INPUT
  end

  def test_part1
    assert_equal 50, D09.new(@input).part1
  end

  def test_part2
    assert_equal 24, D09.new(@input).part2
  end
end
