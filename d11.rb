# frozen_string_literal: true

class D11
  def initialize(input)
    @input = input
  end

  def part1
    parse
    @path_cache = {}
    count_paths('you', 'out')
  end

  def part2
    parse
    @path_cache = {}

    (count_paths('svr', 'dac') * count_paths('dac', 'fft') * count_paths('fft', 'out')) +
      (count_paths('svr', 'fft') * count_paths('fft', 'dac') * count_paths('dac', 'out'))
  end

  def count_paths(from, to)
    return @path_cache[[from, to]] if @path_cache.key?([from, to])
    return 1 if from == to

    @path_cache[[from, to]] = @devices.fetch(from, []).sum { |node| count_paths(node, to) }
  end

  def parse
    @devices = {}
    @input.strip.split("\n").each do |row|
      k, v = row.split(': ')
      @devices[k] = v.split
    end
  end
end
