# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'd01'

class TestD01 < Minitest::Test
  def setup
    @input = <<~INPUT
      L68
      L30
      R48
      L5
      R60
      L55
      L1
      L99
      R14
      L82
    INPUT
  end

  def test_part1
    assert_equal 3, D01.new(@input).part1
  end

  def test_part2
    assert_equal 6, D01.new(@input).part2
  end
end
