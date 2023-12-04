defmodule AdventOfCode.Day02 do
  @bag_contents %{
    "blue" => 14,
    "green" => 13,
    "red" => 12
  }

  @empty_bag_contents %{
    "blue" => 0,
    "green" => 0,
    "red" => 0
  }

  def part1(args) do
    String.split(args, "\n", trim: true)
    |> Enum.map(fn line ->
      ["Game " <> id, results] = String.split(line, ": ", trim: true)

      valid? =
        String.split(results, "; ", trim: true)
        |> Enum.all?(fn draw ->
          String.split(draw, ",", trim: true)
          |> Enum.all?(fn draw ->
            [count, color] = String.split(draw, " ", trim: true)
            String.to_integer(count) <= Map.get(@bag_contents, color)
          end)
        end)

      if valid? do
        String.to_integer(id)
      else
        0
      end
    end)
    |> Enum.sum()
  end

  def part2(args) do
    String.split(args, "\n", trim: true)
    |> Enum.map(fn line ->
      ["Game " <> id, results] = String.split(line, ": ", trim: true)

      min_bag =
        String.split(results, "; ", trim: true)
        |> Enum.reduce(@empty_bag_contents, fn draw, acc ->
          String.split(draw, ",", trim: true)
          |> Enum.reduce(acc, fn draw, acc2 ->
            [count, color] = String.split(draw, " ", trim: true)

            Map.put(acc2, color, max(String.to_integer(count), Map.get(acc2, color)))
          end)
        end)

      min_bag["red"] * min_bag["green"] * min_bag["blue"]
    end)
    |> Enum.sum()
  end
end
