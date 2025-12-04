# frozen_string_literal: true

require 'pry'

class D04
  def initialize(input)
    @input = input
    @original_grid = parse
  end

  def part1
    grid = @original_grid.map(&:dup)
    find_accessible_cells(grid).length
  end

  def part2
    grid = @original_grid.map(&:dup)
    accessible_cells_count = 0
    loop do
      accessible_cells = find_accessible_cells(grid)
      break if accessible_cells.empty?

      accessible_cells.each do |row_idx, col_idx|
        grid[row_idx][col_idx] = '.'
      end
      accessible_cells_count += accessible_cells.length
    end
    accessible_cells_count
  end

  def find_accessible_cells(grid)
    accessible_cells = []
    for row_idx in 0...grid.length
      row = grid[row_idx]
      for col_idx in 0...row.length
        char = row[col_idx]
        next unless char == '@'

        accessible_cells << [row_idx, col_idx] if can_access?(row_idx, col_idx, grid)
      end
    end
    accessible_cells
  end

  def parse
    @input.strip.split("\n")
  end

  def can_access?(row_idx, col_idx, grid)
    adjacent_count = 0
    adjacent_count += 1 if row_idx > 0 && col_idx > 0 && grid[row_idx - 1][col_idx - 1] == '@'
    adjacent_count += 1 if row_idx > 0 && grid[row_idx - 1][col_idx] == '@'
    adjacent_count += 1 if row_idx > 0 && col_idx < grid[row_idx].length - 1 && grid[row_idx - 1][col_idx + 1] == '@'
    adjacent_count += 1 if row_idx < grid.length - 1 && grid[row_idx + 1][col_idx] == '@'
    adjacent_count += 1 if col_idx > 0 && grid[row_idx][col_idx - 1] == '@'
    adjacent_count += 1 if row_idx < grid.length - 1 && col_idx > 0 && grid[row_idx + 1][col_idx - 1] == '@'
    adjacent_count += 1 if col_idx < grid[row_idx].length - 1 && grid[row_idx][col_idx + 1] == '@'
    if row_idx < grid.length - 1 && col_idx < grid[row_idx].length - 1 && grid[row_idx + 1][col_idx + 1] == '@'
      adjacent_count += 1
    end
    adjacent_count < 4
  end
end
