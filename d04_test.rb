# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'd04'

class TestD04 < Minitest::Test
  def setup
    @example = <<~EXAMPLE
      ..@@.@@@@.
      @@@.@.@.@@
      @@@@@.@.@@
      @.@@@@..@.
      @@.@@@@.@@
      .@@@@@@@.@
      .@.@.@.@@@
      @.@@@.@@@@
      .@@@@@@@@.
      @.@.@@@.@.
    EXAMPLE
  end

  def test_part1
    assert_equal 13, D04.new(@example).part1
  end

  def test_part2
    assert_equal 43, D04.new(@example).part2
  end
end
