# frozen_string_literal: true

OP_TO_STARTER_VAL = {
  '*': 1,
  '+': 0
}.freeze

class D06
  def initialize(input)
    @input = input
  end

  def part1
    parse1
    calculate(@operators, @nums)
  end

  def part2
    parse2
    calculate(@operators, @nums)
  end

  def parse1
    lines = @input.strip.split("\n")
    @operators = lines.last.split
    @nums = lines[0..-2].map { |line| line.split.map(&:to_i) }.transpose
  end

  def parse2
    lines = @input.strip.split("\n")
    @operators = lines.last.split
    transposed_chars = lines[0..-2].map(&:chars).transpose
    @nums = transposed_chars
            .chunk { |row| row.all? { |c| c == ' ' } }
            .reject { |is_separator, _| is_separator }
            .map { |_, group| group.map { |row| row.join.to_i } }
  end

  private

  def calculate(ops, nums)
    intermediate_results = []
    # TODO: use `zip`?
    ops.each_with_index do |op, i|
      intermediate_res = OP_TO_STARTER_VAL[op.to_sym]
      # TODO: use `reduce`?
      nums[i].each do |n|
        # TODO: `public_send` instead of `if op == '*'`?
        if op == '*'
          intermediate_res *= n
        else
          intermediate_res += n
        end
      end
      intermediate_results << intermediate_res
    end
    intermediate_results.sum
  end
end
