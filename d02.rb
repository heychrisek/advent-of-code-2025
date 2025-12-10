# frozen_string_literal: true

class D02
  def initialize(input)
    @input = input
  end

  def part1
    parse
    @ranges.sum { |first, last| (first..last).sum { |i| invalid?(i) ? i : 0 } }
  end

  def part2
    parse
    @ranges.sum { |first, last| (first..last).sum { |i| invalid_2?(i) ? i : 0 } }
  end

  def invalid?(n)
    s = n.to_s
    s.size.even? && s[0..(s.size / 2) - 1] == s[s.size / 2..]
  end

  def invalid_2?(n)
    s = n.to_s
    (1..s.size / 2).each do |len|
      next unless (s.size % len).zero?

      pattern = s[0, len]
      return true if s == pattern * (s.size / len)
    end
    false
  end

  def parse
    @ranges = @input.strip.split(',').map { |x| x.split('-').map(&:to_i) }
  end
end
