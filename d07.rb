# frozen_string_literal: true

class D07
  def initialize(input)
    @input = input
  end

  def part1
    parse
    start_col = @rows[0].index('S')
    count_splits(1, start_col)
  end

  def part2
    parse
    start_col = @rows[0].index('S')
    count_timelines(1, start_col)
  end

  private

  def count_splits(row_i, col_i)
    return 0 if out_of_bounds?(row_i, col_i)

    case @rows[row_i][col_i]
    when '^'
      @rows[row_i][col_i] = '*'
      1 + count_splits(row_i, col_i - 1) + count_splits(row_i, col_i + 1)
    when '.'
      @rows[row_i][col_i] = '|'
      count_splits(row_i + 1, col_i)
    else
      0
    end
  end

  def count_timelines(row_i, col_i, memo = {})
    return 1 if out_of_bounds?(row_i, col_i)

    key = [row_i, col_i]
    return memo[key] if memo.key?(key)

    memo[key] = case @rows[row_i][col_i]
                when '^'
                  count_timelines(row_i, col_i - 1, memo) + count_timelines(row_i, col_i + 1, memo)
                when '.'
                  count_timelines(row_i + 1, col_i, memo)
                else
                  0
                end
  end

  def out_of_bounds?(row_i, col_i)
    row_i.negative? || col_i.negative? || row_i >= @rows.size || col_i >= @rows[row_i].size
  end

  def parse
    @rows = @input.strip.split("\n")
  end
end
