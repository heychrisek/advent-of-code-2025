# frozen_string_literal: true

class D08
  def initialize(input)
    @input = input
  end

  def part1(n = 1000)
    parse
    circuit_link = set_up_circuits

    @pairs.first(n).each do |_dist, p1, p2|
      union(p1.to_s, p2.to_s, circuit_link)
    end

    circuit_sizes = Hash.new(0)
    @points.each { |p| circuit_sizes[find_circuit_id(p.to_s, circuit_link)] += 1 }

    circuit_sizes.values.max(3).reduce(:*)
  end

  def part2
    parse
    circuit_link = set_up_circuits

    last_connection = nil

    @pairs.each do |_dist, p1, p2|
      circuit1 = find_circuit_id(p1.to_s, circuit_link)
      circuit2 = find_circuit_id(p2.to_s, circuit_link)

      if circuit1 != circuit2
        union(p1.to_s, p2.to_s, circuit_link)
        last_connection = [p1, p2]
      end
    end
    last_connection[0][0] * last_connection[1][0]
  end

  def distance(p1, p2)
    ((p1[0] - p2[0])**2) + ((p1[1] - p2[1])**2) + ((p1[2] - p2[2])**2)
  end

  def find_circuit_id(point, circuit_link)
    current = point
    current = circuit_link[current] while circuit_link[current] != current
    current
  end

  def union(p1, p2, circuit_link)
    circuit1 = find_circuit_id(p1, circuit_link)
    circuit2 = find_circuit_id(p2, circuit_link)
    circuit_link[circuit1] = circuit2
  end

  def set_up_circuits
    circuit_link = {}
    @points.each { |p| circuit_link[p.to_s] = p.to_s }
    circuit_link
  end

  def parse
    @points = @input.strip.split("\n").map { |x| x.split(',').map(&:to_i) }
    @pairs = []
    @points.each_with_index do |p1, i|
      @points[(i + 1)..].each do |p2|
        @pairs << [distance(p1, p2), p1, p2]
      end
    end
    @pairs.sort_by! { |p| p[0] }
  end
end
