defmodule AdventOfCode.Day04 do
  def part1(args) do
    # args =
    #   "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53\nCard 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19\nCard 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1\nCard 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83\nCard 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36\nCard 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11\n"

    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn card ->
      ["Card " <> card, values] = String.split(card, ": ", trim: true)
      [winning, other] = String.split(values, "|", trim: true)
      winning_numbers = String.split(winning, " ", trim: true)
      my_numbers = String.split(other, " ", trim: true)

      Enum.reduce(my_numbers, 0, fn num, acc ->
        if Enum.member?(winning_numbers, num) do
          if acc == 0 do
            1
          else
            acc * 2
          end
        else
          acc
        end
      end)
    end)
    |> Enum.sum()
  end

  def part2(args) do
    # args =
    #   "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53\nCard 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19\nCard 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1\nCard 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83\nCard 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36\nCard 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11\n"

    cards =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn card ->
        ["Card " <> card, values] = String.split(card, ": ", trim: true)
        [winning, other] = String.split(values, "|", trim: true)
        winning_numbers = String.split(winning, " ", trim: true)
        my_numbers = String.split(other, " ", trim: true)

        win_count =
          Enum.filter(my_numbers, fn num ->
            Enum.member?(winning_numbers, num)
          end)
          |> length()

        {String.to_integer(String.trim(card)), win_count}
      end)

    process_cards(cards, cards, length(cards))
  end

  def process_cards([], all_cards, total), do: total

  def process_cards(cards_to_process, all_cards, total) do
    {new_cards, total} =
      Enum.reduce(cards_to_process, {[], total}, fn {card, win_count}, {new_cards, total} ->
        if win_count == 0 do
          {new_cards, total}
        else
          {Enum.slice(all_cards, card..(card + win_count - 1)) ++ new_cards, total + win_count}
        end
      end)

    process_cards(new_cards, all_cards, total)
  end
end
