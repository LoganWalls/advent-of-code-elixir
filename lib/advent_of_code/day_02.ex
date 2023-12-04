defmodule AdventOfCode.Day02 do
  def parse_color(r, s) do
    case Regex.run(r, s) do
      nil ->
        # IO.inspect({r, s, "not matched"})
        0

      captures ->
        List.last(captures) |> String.to_integer()
    end
  end

  def parse_subsets(s) do
    case Regex.run(~r/Game ([0-9]+)/, s) do
      nil ->
        # IO.inspect({s, "Not ID matched"})
        nil

      captures ->
        id = captures |> List.last() |> String.to_integer()

        colors =
          s
          |> String.split(":")
          |> List.last()
          |> String.split(";")
          |> Enum.reduce(%{red: [], green: [], blue: []}, fn s, colors ->
            colors
            |> Map.update!(:red, &[parse_color(~r/([0-9]+) red/, s) | &1])
            |> Map.update!(:green, &[parse_color(~r/([0-9]+) green/, s) | &1])
            |> Map.update!(:blue, &[parse_color(~r/([0-9]+) blue/, s) | &1])
          end)

        %{id: id, colors: colors}
    end
  end

  def part1(input) do
    claimed_contents = %{red: 12, green: 13, blue: 14}
    games = input |> String.split("\n") |> Enum.map(&parse_subsets/1) |> Enum.filter(&(&1 != nil))

    games
    |> Enum.reduce(0, fn g, total ->
      possible? =
        [:red, :green, :blue]
        |> Enum.all?(fn key ->
          claimed = Map.get(claimed_contents, key, 0)
          observed = Map.get(g.colors, key, []) |> Enum.max()
          claimed >= observed
        end)

      if possible? do
        total + g.id
      else
        total
      end
    end)
  end

  def part2(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_subsets/1)
    |> Enum.filter(&(&1 != nil))
    |> Enum.reduce(0, fn g, total ->
      power = g.colors |> Enum.map(fn {_, v} -> Enum.max(v) end) |> Enum.product()
      power + total
    end)
  end
end
