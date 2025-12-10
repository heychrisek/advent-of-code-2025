# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'd02'

class TestD02 < Minitest::Test
  def setup
    @input = <<~INPUT
      11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
    INPUT
  end

  def test_part1
    assert_equal 1_227_775_554, D02.new(@input).part1
  end

  def test_part2
    assert_equal 4_174_379_265, D02.new(@input).part2
  end
end
