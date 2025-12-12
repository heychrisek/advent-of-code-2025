# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'd12'

class TestD12 < Minitest::Test
  def setup
    @input = <<~INPUT
      0:
      ###
      ##.
      ##.

      1:
      ###
      ##.
      .##

      2:
      .##
      ###
      ##.

      3:
      ##.
      ###
      ##.

      4:
      ###
      #..
      ###

      5:
      ###
      .#.
      ###

      4x4: 0 0 0 0 2 0
      12x5: 1 0 1 0 2 2
      12x5: 1 0 1 0 3 2

    INPUT
  end

  def test_part1
    assert_equal 2, D12.new(@input).part1
  end
end
