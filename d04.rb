# frozen_string_literal: true

class D04
  def initialize(input)
    @input = input
    @original_grid = parse
  end

  def part1
    grid = duplicate_grid
    find_accessible_cells(grid).length
  end

  def part2
    grid = duplicate_grid
    count = 0
    loop do
      accessible_cells = find_accessible_cells(grid)
      break if accessible_cells.empty?

      accessible_cells.each { |row_i, col_i| grid[row_i][col_i] = '.' }
      count += accessible_cells.length
    end
    count
  end

  def find_accessible_cells(grid)
    grid.each_with_index.flat_map do |row, row_i|
      row.each_char.with_index.filter_map do |char, col_i|
        next unless char == '@'
        next unless can_access?(row_i, col_i, grid)

        [row_i, col_i]
      end
    end
  end

  def parse
    @input.strip.split("\n")
  end

  def duplicate_grid
    @original_grid.map(&:dup)
  end

  def can_access?(row_i, col_i, grid)
    neighbor_count = count_neighbors(row_i, col_i, grid)
    neighbor_count < 4
  end

  def count_neighbors(row_i, col_i, grid)
    directions = [
      [-1, -1], [-1, 0], [-1, 1],
      [0, -1], [0, 1],
      [1, -1], [1, 0], [1, 1]
    ]

    directions.count do |dr, dc|
      new_row = row_i + dr
      new_col = col_i + dc
      in_bounds?(new_row, new_col, grid) && grid[new_row][new_col] == '@'
    end
  end

  def in_bounds?(row_i, col_i, grid)
    row_i >= 0 && row_i < grid.length &&
      col_i >= 0 && col_i < grid[row_i].length
  end
end
