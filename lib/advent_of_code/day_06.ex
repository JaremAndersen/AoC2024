defmodule AdventOfCode.Day06 do
  def part1(args) do
    # args = "Time:      7  15   30\nDistance:  9  40  200\n"

    [times, distances] =
      String.split(args, "\n", trim: true)
      |> Enum.map(fn line ->
        [_, values] = String.split(line, ": ", trim: true)

        String.split(values, " ", trim: true)
        |> Enum.map(fn value ->
          String.to_integer(value)
        end)
      end)

    Enum.with_index(times)
    |> Enum.map(fn {time, idx} ->
      build_options(time)
      |> Enum.filter(fn distance ->
        distance > Enum.at(distances, idx)
      end)
      |> length()
    end)
    |> Enum.product()
  end

  def build_options(time) do
    Enum.map(0..time, fn hold ->
      (time - hold) * hold
    end)
  end

  def build_options_try_hard(time, record) do
    start = time / 2
    even = rem(time, 2) == 0
    start_rounded = Kernel.trunc(start)

    Enum.reduce_while(start_rounded..time, 0, fn hold, acc ->
      distance = (time - hold) * hold

      cond do
        distance <= record and acc == 0 ->
          {:cont, 0}

        distance > record and even and acc == 0 ->
          {:cont, acc + 1}

        distance > record and even ->
          {:cont, acc + 2}

        distance > record and !even and acc == 0 ->
          {:cont, acc + 1}

        distance > record and !even ->
          {:cont, acc + 2}

        true ->
          {:halt, acc}
      end
    end)
  end

  def part2(args) do
    # args = "Time:      7  15   30\nDistance:  9  40  200\n"

    [time, record] =
      String.split(args, "\n", trim: true)
      |> Enum.map(fn line ->
        [_, values] = String.split(line, ": ", trim: true)

        String.replace(values, " ", "") |> String.to_integer()
      end)

    # build_options(time)
    # |> Enum.filter(fn distance ->
    #   distance > record
    # end)
    # |> length()

    build_options_try_hard(time, record)
  end
end
