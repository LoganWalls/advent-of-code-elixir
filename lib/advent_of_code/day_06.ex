defmodule AdventOfCode.Day06 do
  def ways_to_beat(direction, hold, duration, record, total) do
    hold_valid = hold > 0 and hold < duration
    distance = (duration - hold) * hold

    if hold_valid and distance > record do
      next_hold =
        case direction do
          :left -> hold - 1
          :right -> hold + 1
        end

      ways_to_beat(direction, next_hold, duration, record, total + 1)
    else
      total
    end
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn s ->
      s
      |> String.split(":", trim: true)
      |> List.last()
    end)
  end

  def part1(lines) do
    [durations, records] =
      parse(lines)
      |> Enum.map(fn line ->
        line
        |> String.split(" ", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    Enum.zip(durations, records)
    |> Enum.reduce(1, fn {duration, record}, result ->
      center = trunc(duration / 2)

      result *
        (ways_to_beat(:left, center, duration, record, 0) +
           ways_to_beat(:right, center + 1, duration, record, 0))
    end)
  end

  def part2(lines) do
    [duration, record] =
      parse(lines)
      |> Enum.map(fn line ->
        line
        |> String.replace(" ", "")
        |> String.to_integer()
      end)

    center = trunc(duration / 2)

    ways_to_beat(:left, center, duration, record, 0) +
      ways_to_beat(:right, center + 1, duration, record, 0)
  end
end
