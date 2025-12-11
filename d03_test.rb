# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'd03'

class TestD03 < Minitest::Test
  def setup
    @input = <<~INPUT
      987654321111111
      811111111111119
      234234234234278
      818181911112111
    INPUT
  end

  def test_part1
    assert_equal 357, D03.new(@input).part1
  end

  def test_part2
    assert_equal 3_121_910_778_619, D03.new(@input).part2
  end
end
