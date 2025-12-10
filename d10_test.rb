# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'd10'

class TestD10 < Minitest::Test
  def setup
    @input = <<~INPUT
      [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
      [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
      [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
    INPUT
  end

  def test_part1
    assert_equal 7, D10.new(@input).part1
  end

  def test_part2
    assert_equal 33, D10.new(@input).part2
  end
end
