# frozen_string_literal: true

class D05
  def initialize(input)
    @input = input
    @ranges = []
    @ingredient_ids = []
  end

  def part1
    parse
    @ingredient_ids.count do |ingredient_id|
      @ranges.any? do |start, finish|
        (start..finish).cover?(ingredient_id)
      end
    end
  end

  def part2
    parse
    @ranges.sum do |start, finish|
      finish - start + 1
    end
  end

  def parse
    ranges_str, ingredients_str = @input.strip.split("\n\n")
    parsed_ranges = ranges_str.strip.split("\n").map { |range| range.split('-').map(&:to_i) }
    @ranges = merge_ranges(parsed_ranges)
    @ingredient_ids = ingredients_str.strip.split("\n").map(&:to_i)
  end

  def merge_ranges(ranges)
    return [] if ranges.empty?

    sorted = ranges.sort_by(&:first)
    merged = [sorted.first]

    sorted[1..].each do |current_start, current_end|
      last_start, last_end = merged.last

      if current_start <= last_end + 1
        merged[-1] = [last_start, [last_end, current_end].max]
      else
        merged << [current_start, current_end]
      end
    end

    merged
  end
end
