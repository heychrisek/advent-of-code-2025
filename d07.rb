# frozen_string_literal: true

require 'pry'

class D07
  def initialize(input)
    @input = input
  end

  def part1
    parse
    @count = 0
    i = @rows[0].index('S')
    count_splits(1, i)
    @count
  end

  def part2
    parse
    i = @rows[0].index('S')
    count_timelines(1, i, {})
  end

  def count_splits(row_i, col_i)
    return if row_i >= @rows.length || col_i >= @rows[row_i].length || row_i.negative? || col_i.negative?

    if @rows[row_i][col_i] == '^'
      @rows[row_i][col_i] = '*'
      @count += 1
      count_splits(row_i, col_i - 1)
      count_splits(row_i, col_i + 1)
    elsif @rows[row_i][col_i] == '.'
      @rows[row_i][col_i] = '|'
      count_splits(row_i + 1, col_i)
    end
  end

  # rubocop:disable Metrics/PerceivedComplexity
  def count_timelines(row_i, col_i, memo)
    return 1 if row_i >= @rows.length || col_i >= @rows[row_i].length || row_i.negative? || col_i.negative?

    key = [row_i, col_i]
    return memo[key] if memo.key?(key)

    memo[key] = if @rows[row_i][col_i] == '^'
                  count_timelines(row_i, col_i - 1, memo) + count_timelines(row_i, col_i + 1, memo)
                elsif @rows[row_i][col_i] == '.'
                  count_timelines(row_i + 1, col_i, memo)
                else
                  0
                end
  end
  # rubocop:enable Metrics/PerceivedComplexity

  def parse
    @rows = @input.strip.split("\n")
  end
end
