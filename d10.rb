# frozen_string_literal: true

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

  # rubocop:disable Metrics
  def min_presses_for_joltage(row)
    target = row[:joltage][:target]
    buttons = row[:buttons]
    min = nil

    max_presses_per_button = buttons.map do |button_counters|
      button_counters.map { |counter| target[counter] }.min
    end

    ranges = max_presses_per_button.map { |max| (0..max).to_a }
    ranges[0].product(*ranges[1..]).each do |press_counts|
      state = [0] * target.size
      total_presses = 0

      press_counts.each_with_index do |times, button_idx|
        total_presses += times
        buttons[button_idx].each { |counter| state[counter] += times }
      end

      min = total_presses if state == target && (min.nil? || total_presses < min)
    end

    min
  end
  # rubocop:enable Metrics

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
