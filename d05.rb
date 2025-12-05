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
      @ranges.any? do |range|
        range[0] <= ingredient_id && range[1] >= ingredient_id
      end
    end
  end

  def part2
    parse
    sum = 0
    @ranges.each do |range|
      sum += range[1] - range[0] + 1
    end
    sum
  end

  def parse
    parsed_ranges, parsed_ingredients = @input.strip.split("\n\n")
    parsed_ranges = parsed_ranges.strip.split("\n").map { |range| range.split('-').map(&:to_i) }
    @ranges = merge_ranges(parsed_ranges)
    @ingredient_ids = parsed_ingredients.strip.split("\n").map(&:to_i)
  end

  def merge_ranges(ranges)
    return [] if ranges.empty?

    sorted = ranges.sort_by { |start, _end| start }
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
