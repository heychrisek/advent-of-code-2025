# frozen_string_literal: true

require 'set'
require 'timeout'

# rubocop:disable Metrics
class D12
  def initialize(input)
    @input = input
    @presents = []
    @regions = []
  end

  def part1
    parse
    @orientations = @presents.map { |shape| all_orientations(shape) }
    @regions.count { |region| can_fit_region?(region) }
  end

  def can_fit_region?(region)
    width = region[:width]
    height = region[:height]
    counts = region[:counts]

    # area check
    total_cells = counts.each_with_index.sum { |count, idx| count * @presents[idx].length }
    return false if total_cells > width * height

    shapes_to_place = []
    counts.each_with_index do |count, shape_idx|
      count.times { shapes_to_place << shape_idx }
    end

    # place bigger shapes first
    shapes_to_place.sort_by! { |idx| -@presents[idx].length }

    occupied = Set.new
    begin
      Timeout.timeout(1) do
        solve(shapes_to_place, 0, occupied, width, height)
      end
    rescue Timeout::Error
      false
    end
  end

  def solve(shapes_to_place, idx, occupied, width, height)
    return true if idx == shapes_to_place.length

    shape_idx = shapes_to_place[idx]

    @orientations[shape_idx].each do |orientation|
      (0...height).each do |row|
        (0...width).each do |col|
          if can_place?(orientation, row, col, occupied, width, height)
            new_occupied = place(orientation, row, col, occupied)
            return true if solve(shapes_to_place, idx + 1, new_occupied, width, height)
          end
        end
      end
    end

    false
  end

  def can_place?(shape, row, col, occupied, width, height)
    shape.all? do |dr, dc|
      r = row + dr
      c = col + dc
      r >= 0 && r < height && c >= 0 && c < width && !occupied.include?([r, c])
    end
  end

  def place(shape, row, col, occupied)
    new_occupied = occupied.dup
    shape.each do |dr, dc|
      new_occupied.add([row + dr, col + dc])
    end
    new_occupied
  end

  def parse
    @input.strip.split("\n\n").each do |block|
      if /^\d+:\n/.match(block)
        lines = block.split("\n")
        index = lines[0].chomp(':').to_i
        shape_lines = lines[1..]

        coords = []
        shape_lines.each_with_index do |line, row|
          line.chars.each_with_index do |char, col|
            coords << [row, col] if char == '#'
          end
        end
        @presents[index] = coords
      else
        block.split("\n").each do |line|
          m = /(\d+)x(\d+):\s*(.*)/.match(line)
          next unless m

          width = m[1].to_i
          height = m[2].to_i
          counts = m[3].split.map(&:to_i)
          @regions << { width: width, height: height, counts: counts }
        end
      end
    end
  end

  # all shapes are 3x3, so max_row = max_col = 2
  def rotate_once(shape)
    shape.map { |r, c| [c, 2 - r] }.sort
  end

  def flip(shape)
    shape.map { |r, c| [r, 2 - c] }.sort
  end

  def all_orientations(shape)
    orientations = []
    current = shape.sort

    4.times do
      orientations << current
      current = rotate_once(current)
    end

    current = flip(shape)
    4.times do
      orientations << current
      current = rotate_once(current)
    end

    orientations.uniq
  end
end
# rubocop:enable Metrics
