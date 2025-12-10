# frozen_string_literal: true

# Part 2 uses a Python ILP solver (scipy) for performance.
# To set up the Python environment:
#
#   python3 -m venv .venv
#   source .venv/bin/activate
#   pip install scipy numpy
#
# The Ruby code will automatically use .venv/bin/python3 if it exists.

require 'json'
require 'open3'

class D10
  def initialize(input)
    @input = input
  end

  def part1
    parse
    @data.sum { |row| min_presses_for_lights(row) }
  end

  def part2
    parse
    @data.sum { |row| min_presses_for_joltage(row) }
  end

  def min_presses_for_lights(row)
    target_state = row[:indicator_lights][:target_state]
    buttons = row[:buttons]
    min = nil

    # could do bitwise but using all permutations of booleans for now
    [false, true].repeated_permutation(buttons.size).each do |buttons_to_press|
      state = row[:indicator_lights][:current_state].dup
      presses = 0

      buttons_to_press.each_with_index do |should_press, i|
        next unless should_press

        presses += 1
        # push button, toggle indicator lights
        buttons[i].each { |light| state[light] = !state[light] }
      end

      min = presses if state == target_state && (min.nil? || presses < min)
    end

    min
  end

  def min_presses_for_joltage(row)
    target = row[:joltage][:target]
    buttons = row[:buttons]

    # Build incidence matrix A where A[i][j] = 1 if button j affects counter i
    a_data = Array.new(target.size) { Array.new(buttons.size, 0) }
    buttons.each_with_index do |counters, j|
      counters.each { |i| a_data[i][j] = 1 }
    end

    solve_with_python_ilp(a_data, target)
  end

  # Solve using Python scipy.optimize.milp (Integer Linear Programming)
  def solve_with_python_ilp(a_data, target)
    input = JSON.generate({ A: a_data, target: target })
    script_path = File.join(__dir__, 'd10_solve_ilp.py')

    # Use venv python if available, otherwise system python3
    venv_python = File.join(__dir__, '.venv', 'bin', 'python3')
    python_cmd = File.exist?(venv_python) ? venv_python : 'python3'

    stdout, _stderr, status = Open3.capture3(python_cmd, script_path, stdin_data: input)
    raise 'Python ILP solver failed' unless status.success?

    result = JSON.parse(stdout)
    raise result['error'] if result['error']

    result['result']
  end

  # rubocop:disable Metrics/AbcSize
  def parse
    re = /\[(.*)\](.*)\{(.*)\}/
    @data = @input.strip.split("\n").map do |row|
      matches = re.match(row)
      buttons = matches[2][1..-2].split.map { |b| b[1..-2].split(',').map(&:to_i) }
      current = '.' * matches[1].size
      joltage = matches[3].split(',').map(&:to_i)
      { indicator_lights: { current: current,
                            current_state: current.chars.map { |c| c == '#' },
                            target: matches[1],
                            target_state: matches[1].chars.map { |c| c == '#' } },
        buttons: buttons,
        joltage: { target: joltage,
                   current: [0] * joltage.size } }
    end
  end
  # rubocop:enable Metrics/AbcSize
end
