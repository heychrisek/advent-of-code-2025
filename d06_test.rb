# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'd06'

class TestD06 < Minitest::Test
  def setup
    # rubocop:disable Layout/TrailingWhitespace
    @input = <<~INPUT
      123 328  51 64 
       45 64  387 23 
        6 98  215 314
      *   +   *   +  
    INPUT
    # rubocop:enable Layout/TrailingWhitespace
  end

  def test_part1
    assert_equal 4_277_556, D06.new(@input).part1
  end

  def test_part2
    assert_equal 3_263_827, D06.new(@input).part2
  end
end
