# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'd05'

class TestD05 < Minitest::Test
  def setup
    @input = <<~INPUT
      3-5
      10-14
      16-20
      12-18

      1
      5
      8
      11
      17
      32
    INPUT
  end

  def test_part1
    assert_equal 3, D05.new(@input).part1
  end

  def test_part2
    assert_equal 14, D05.new(@input).part2
  end
end
