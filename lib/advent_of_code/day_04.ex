defmodule AdventOfCode.Day04 do
  def parse_numbers(s) do
    s |> String.split(~r/[[:space:]]+/, trim: true) |> MapSet.new()
  end

  def parse_card(line) do
    [left, winning] = String.split(line, "|")
    [card, have] = String.split(left, ":")

    %{
      id: card |> String.replace(~r/Card[[:space:]]+/, "") |> String.to_integer(),
      n_matches: MapSet.intersection(parse_numbers(have), parse_numbers(winning)) |> MapSet.size()
    }
  end

  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(0, fn line, total ->
      card = parse_card(line)

      points =
        if card.n_matches > 0 do
          Integer.pow(2, card.n_matches - 1)
        else
          0
        end

      points + total
    end)
  end

  def part2(input) do
    cards = input |> String.split("\n", trim: true) |> Enum.map(&parse_card/1)

    {total, _} =
      Enum.reduce(cards, {0, Map.new()}, fn card, {total, counts} ->
        card_count = Map.get(counts, card.id, 0) + 1

        counts =
          if card.n_matches > 0 do
            Range.new(card.id + 1, card.id + card.n_matches)
            |> Enum.reduce(counts, fn i, c ->
              Map.update(c, i, card_count, fn prev -> prev + card_count end)
            end)
          else
            counts
          end

        {total + card_count, counts}
      end)

    total
  end
end
