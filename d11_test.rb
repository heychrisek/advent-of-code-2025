# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'd11'

class TestD11 < Minitest::Test
  # rubocop:disable Metrics/MethodLength
  def setup
    @input1 = <<~INPUT
      aaa: you hhh
      you: bbb ccc
      bbb: ddd eee
      ccc: ddd eee fff
      ddd: ggg
      eee: out
      fff: out
      ggg: out
      hhh: ccc fff iii
      iii: out
    INPUT

    @input2 = <<~INPUT
      svr: aaa bbb
      aaa: fft
      fft: ccc
      bbb: tty
      tty: ccc
      ccc: ddd eee
      ddd: hub
      hub: fff
      eee: dac
      dac: fff
      fff: ggg hhh
      ggg: out
      hhh: out
    INPUT
  end
  # rubocop:enable Metrics/MethodLength

  def test_part1
    assert_equal 5, D11.new(@input1).part1
  end

  def test_part2
    assert_equal 2, D11.new(@input2).part2
  end
end
