defmodule AdventOfCode.Day01 do
  def part1(args) do
    String.trim(args)
    |> String.split("\n")
    |> Enum.map(fn line ->
      numbers = String.replace(line, ~r/[^\d]/, "")
      String.to_integer(String.at(numbers, 0) <> String.at(numbers, -1))
    end)
    |> Enum.sum()
  end

  def replace_string_numbers(string) do
    numbers = %{
      "zero" => "0",
      "one" => "1",
      "two" => "2",
      "three" => "3",
      "four" => "4",
      "five" => "5",
      "six" => "6",
      "seven" => "7",
      "eight" => "8",
      "nine" => "9"
    }

    Map.get(numbers, string, string)
  end

  def part2(args) do
    String.trim(args)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      numbers =
        Regex.scan(
          ~r/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/,
          line,
          capture: :all_but_first
        )
        |> List.flatten()
        |> Enum.map(fn x ->
          replace_string_numbers(x)
        end)
        |> Enum.join()

      String.to_integer(String.at(numbers, 0) <> String.at(numbers, -1))
    end)
    |> Enum.sum()
  end
end
