defmodule AdventOfCode.Day07Test do
  use ExUnit.Case

  import AdventOfCode.Day07

  test "5 of a kind" do
    hand = "aaaaa" |> String.graphemes()

    assert process_hand2(hand, 2)
           |> elem(0)
           |> String.split("", trim: true)
           |> IO.inspect()
           |> Enum.at(0) ==
             "1"

    assert process_hand2(["a", "a", "a", "a", "m"], 2)
           |> elem(0)
           |> String.split("", trim: true)
           |> IO.inspect()
           |> Enum.at(0) ==
             "1"

    assert process_hand2(["a", "a", "a", "m", "m"], 2)
           |> elem(0)
           |> String.split("", trim: true)
           |> IO.inspect()
           |> Enum.at(0) ==
             "1"

    assert process_hand2(["a", "a", "m", "m", "m"], 2)
           |> elem(0)
           |> String.split("", trim: true)
           |> IO.inspect()
           |> Enum.at(0) ==
             "1"

    assert process_hand2(["a", "m", "m", "m", "m"], 2)
           |> elem(0)
           |> String.split("", trim: true)
           |> IO.inspect()
           |> Enum.at(0) ==
             "1"

    assert process_hand2(["m", "m", "m", "m", "m"], 2)
           |> elem(0)
           |> String.split("", trim: true)
           |> IO.inspect()
           |> Enum.at(0) ==
             "1"
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
