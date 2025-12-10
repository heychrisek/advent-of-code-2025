# frozen_string_literal: true

class D01
  def initialize(input)
    @input = input
    @pos = 50
    @zero_count = 0
    @zero_cross_count = 0
  end

  def part1
    parse
    @instructions.each do |instruction|
      handle_instruction(instruction)
    end
    @zero_count
  end

  def part2
    parse
    @instructions.each do |instruction|
      handle_instruction(instruction)
    end
    @zero_cross_count
  end

  def parse
    initialize(@input)
    @instructions = @input.strip.split("\n").map { |x| [x[0], x[1..].to_i] }
  end

  def handle_instruction(instruction)
    direction = instruction[0]
    value = instruction[1]
    increment = direction == 'L' ? -1 : 1

    value.times do
      @pos = (@pos + increment) % 100
      @zero_cross_count += 1 if @pos.zero?
    end
    @zero_count += 1 if @pos.zero?
  end
end
