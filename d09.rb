# frozen_string_literal: true

class D09
  def initialize(input)
    @input = input
  end

  def part1
    parse
    max_area = 0
    @coords.each_with_index do |coord1, i|
      @coords[(i + 1)..].each do |coord2|
        max_area = [max_area, area(coord1, coord2)].max
      end
    end
    max_area
  end

  def part2
    parse
    build_edges
    build_candidate_rectangles
    warn "Parsed #{@coords.length} coordinates, #{@edges.length} edges"
    warn "Generated #{@candidate_rectangles.length} candidate_rectangles, " \
         "largest area: #{@candidate_rectangles.first[0]}"

    find_first_valid_rectangle
  end

  private

  def parse
    @coords = @input.strip.split("\n").map { |x| x.split(',').map(&:to_i) }
  end

  def build_edges
    @edges = []
    @coords.each_with_index do |coord, i|
      next_coord = @coords[(i + 1) % @coords.length]
      @edges << [coord, next_coord]
    end
  end

  def build_candidate_rectangles
    @candidate_rectangles = []
    @coords.each_with_index do |coord1, i|
      @coords[(i + 1)..].each do |coord2|
        min_x, max_x = [coord1[0], coord2[0]].minmax
        min_y, max_y = [coord1[1], coord2[1]].minmax

        @candidate_rectangles << [area(coord1, coord2), min_x, min_y, max_x, max_y]
      end
    end
    @candidate_rectangles.sort_by! { |area, *_| -area }
  end

  def find_first_valid_rectangle
    @candidate_rectangles.each_with_index do |(area, min_x, min_y, max_x, max_y), i|
      warn "Checking box #{i}: area=#{area}" if (i % 10_000).zero?
      return area if valid_rectangle?(min_x, min_y, max_x, max_y)
    end
  end

  def area(coord1, coord2)
    x_diff = (coord1[0] - coord2[0]).abs + 1
    y_diff = (coord1[1] - coord2[1]).abs + 1
    x_diff * y_diff
  end

  # ensure rectangle is fully inside the polygon, no edges cross polygon boundary
  # rubocop:disable Metrics
  def valid_rectangle?(min_x, min_y, max_x, max_y)
    @edges.each do |edge|
      start_x, start_y = edge[0]
      end_x, end_y = edge[1]

      if start_x == end_x # vertical edge
        next if start_x <= min_x || start_x >= max_x
        next if start_y >= max_y && end_y >= max_y
        next if start_y <= min_y && end_y <= min_y
        return false if start_y > min_y && start_y < max_y
        return false if end_y > min_y && end_y < max_y
        return false if start_y <= min_y && end_y >= max_y
        return false if end_y <= min_y && start_y >= max_y
      else
        next if start_y <= min_y || start_y >= max_y
        next if start_x >= max_x && end_x >= max_x
        next if start_x <= min_x && end_x <= min_x
        return false if start_x > min_x && start_x < max_x
        return false if end_x > min_x && end_x < max_x
        return false if start_x <= min_x && end_x >= max_x
        return false if end_x <= min_x && start_x >= max_x
      end
    end

    true
  end
  # rubocop:enable Metrics
end
