# frozen_string_literal: true

require 'pry'
class D03
  def initialize(input)
    @input = input
  end

  def part1
    parse
    @banks.sum { |b| get_largest_joltage(b) }
  end

  def part2
    parse
    @banks.sum { |b| get_largest_joltage_n(b, 12) }
  end

  def get_largest_joltage_n(bank, target)
    n = bank.length
    result = ''
    prev = -1

    target.times do |i|
      max_pos = n - target + i
      best_digit = '0'
      best_pos = prev + 1

      ((prev + 1)..max_pos).each do |pos|
        if bank[pos] > best_digit
          best_digit = bank[pos]
          best_pos = pos
        end
      end

      result += best_digit
      prev = best_pos
    end

    result.to_i
  end

  def get_largest_joltage(bank)
    joltage = 0
    bank.chars.each_with_index do |n1, i|
      bank.chars[i + 1..].each do |n2|
        j = (n1 + n2).to_i
        joltage = j if j > joltage
      end
    end
    joltage
  end

  def parse
    @banks = @input.strip.split("\n")
  end
end
