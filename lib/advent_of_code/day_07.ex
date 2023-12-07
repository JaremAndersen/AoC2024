defmodule AdventOfCode.Day07 do
  def part1(args) do
    # args = "32T3K 765\nT55J5 684\nKK677 28\nKTJJT 220\nQQQJA 483\n"

    String.split(args, "\n", trim: true)
    |> Enum.map(fn line ->
      [hand, bid] = String.split(line, " ", trim: true)
      {String.graphemes(hand) |> replace(), String.to_integer(bid)}
    end)
    |> Enum.map(fn {hand, bid} ->
      result = process_hand(hand, bid)
    end)
    |> Enum.sort(fn {hand1, bid1}, {hand2, bid2} ->
      hand1 > hand2
    end)
    |> Enum.map(fn {{hand, bid}, idx} ->
      bid * (idx + 1)
    end)
    |> Enum.sum()
  end

  def replace(hand) do
    Enum.map(hand, fn card ->
      case card do
        "2" -> "m"
        "3" -> "l"
        "4" -> "k"
        "5" -> "j"
        "6" -> "i"
        "7" -> "h"
        "8" -> "g"
        "9" -> "f"
        "T" -> "e"
        "J" -> "d"
        "Q" -> "c"
        "K" -> "b"
        "A" -> "a"
        _ -> String.to_integer(card)
      end
    end)
  end

  def process_hand(hand, bid) do
    value =
      cond do
        # five of a kind
        Enum.all?(hand, fn card -> Enum.at(hand, 0) == card end) ->
          1

        # four of a kind
        Enum.any?(hand, fn card -> Enum.count(hand, fn c -> c == card end) == 4 end) ->
          2

        # full house
        Enum.any?(hand, fn card -> Enum.count(hand, fn c -> c == card end) == 3 end) and
            Enum.any?(hand, fn card -> Enum.count(hand, fn c -> c == card end) == 2 end) ->
          3

        # three of a kind
        Enum.any?(hand, fn card -> Enum.count(hand, fn c -> c == card end) == 3 end) ->
          4

        # two pair
        Enum.reduce(hand, {[], 0}, fn card, {used, count} ->
          if !Enum.member?(used, card) and Enum.count(hand, fn c -> c == card end) == 2 do
            {used ++ [card], count + 1}
          else
            {used, count}
          end
        end)
        |> elem(1) == 2 ->
          5

        # one pair
        Enum.reduce(hand, {[], 0}, fn card, {used, count} ->
          if !Enum.member?(used, card) and Enum.count(hand, fn c -> c == card end) == 2 do
            {used ++ [card], count + 1}
          else
            {used, count}
          end
        end)
        |> elem(1) == 1 ->
          6

        # high card
        true ->
          7
      end

    {([value] ++ hand) |> Enum.join(), bid}
  end

  def part2(args) do
    # args = "32T3K 765\nT55J5 684\nKK677 28\nKTJJT 220\nQQQJA 483\n"

    String.split(args, "\n", trim: true)
    |> Enum.map(fn line ->
      [hand, bid] = String.split(line, " ", trim: true)
      {String.graphemes(hand) |> replace2(), String.to_integer(bid)}
    end)
    |> Enum.map(fn {hand, bid} ->
      result = process_hand2(hand, bid)
    end)
    |> Enum.sort(fn {hand1, bid1}, {hand2, bid2} ->
      hand1 > hand2
    end)
    |> Enum.with_index()
    |> Enum.map(fn {{hand, bid}, idx} ->
      bid * (idx + 1)
    end)
    |> Enum.sum()
  end

  def replace2(hand) do
    Enum.map(hand, fn card ->
      case card do
        "J" -> "m"
        "2" -> "l"
        "3" -> "k"
        "4" -> "j"
        "5" -> "i"
        "6" -> "h"
        "7" -> "g"
        "8" -> "f"
        "9" -> "e"
        "T" -> "d"
        "Q" -> "c"
        "K" -> "b"
        "A" -> "a"
        _ -> String.to_integer(card)
      end
    end)
  end

  def process_hand2(hand, bid) do
    # m is wild
    m_count = Enum.count(hand, fn card -> card == "m" end)

    value =
      cond do
        # five of a kind
        Enum.any?(hand, fn card ->
          Enum.count(hand, fn c -> c == card and c != "m" end) == 5 - m_count
        end) ->
          1

        # four of a kind
        Enum.any?(hand, fn card ->
          Enum.count(hand, fn c -> c == card and c != "m" end) == 4 - m_count
        end) ->
          2

        # full house
        (Enum.any?(hand, fn card -> Enum.count(hand, fn c -> c == card end) == 3 end) and
           Enum.any?(hand, fn card -> Enum.count(hand, fn c -> c == card end) == 2 end)) or
            (Enum.reduce(hand, {[], 0}, fn card, {used, count} ->
               if !Enum.member?(used, card) and Enum.count(hand, fn c -> c == card end) == 2 do
                 {used ++ [card], count + 1}
               else
                 {used, count}
               end
             end)
             |> elem(1) == 2 and m_count == 1) ->
          3

        # three of a kind
        Enum.any?(hand, fn card -> Enum.count(hand, fn c -> c == card end) == 3 - m_count end) ->
          4

        # two pair
        Enum.reduce(hand, {[], 0}, fn card, {used, count} ->
          if !Enum.member?(used, card) and Enum.count(hand, fn c -> c == card end) == 2 do
            {used ++ [card], count + 1}
          else
            {used, count}
          end
        end)
        |> elem(1) == 2 ->
          5

        # one pair
        m_count == 1 or
            Enum.reduce(hand, {[], 0}, fn card, {used, count} ->
              if !Enum.member?(used, card) and Enum.count(hand, fn c -> c == card end) == 2 do
                {used ++ [card], count + 1}
              else
                {used, count}
              end
            end)
            |> elem(1) == 1 ->
          6

        # high card
        true ->
          7
      end

    {([value] ++ hand) |> Enum.join(), bid}
  end
end
