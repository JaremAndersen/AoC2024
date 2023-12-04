defmodule AdventOfCode.Day03 do
  def part1(args) do
    # args =
    #   "467..114..\n...*......\n..35..633.\n......=...\n617*......\n.....+.58.\n..592.....\n......755.\n...$.*....\n.664.598..\n"

    symbols =
      String.replace(args, ~r/[0-9\n.]/, "")
      |> String.split("", trim: true)
      |> Enum.uniq()

    grid =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn row ->
        String.graphemes(row)
      end)

    symbol_locations = find_symbols(grid, symbols)

    adjacent_numbers =
      symbol_locations
      |> Enum.map(fn {x, y} ->
        find_adjacent_numbers(grid, x, y)
      end)
      |> List.flatten()
      |> Enum.sum()
  end

  def find_adjacent_numbers(grid, x, y) do
    u = {Enum.at(grid, x - 1) |> Enum.at(y), x - 1, y}
    d = {Enum.at(grid, x + 1) |> Enum.at(y), x + 1, y}
    l = {Enum.at(grid, x) |> Enum.at(y - 1), x, y - 1}
    r = {Enum.at(grid, x) |> Enum.at(y + 1), x, y + 1}
    ul = {Enum.at(grid, x - 1) |> Enum.at(y - 1), x - 1, y - 1}
    ur = {Enum.at(grid, x - 1) |> Enum.at(y + 1), x - 1, y + 1}
    dl = {Enum.at(grid, x + 1) |> Enum.at(y - 1), x + 1, y - 1}
    dr = {Enum.at(grid, x + 1) |> Enum.at(y + 1), x + 1, y + 1}

    [u, d, l, r, ul, ur, dl, dr]
    |> Enum.reduce([], fn {value, x, y}, acc ->
      Integer.parse(value)
      |> case do
        {num, _} -> acc ++ [get_full_number(grid, x, y)]
        _ -> acc
      end
    end)
    |> Enum.uniq()
  end

  def get_full_number(grid, x, y) do
    {sx, sy} = find_number_start(grid, x, y)
    {ex, ey} = find_number_end(grid, x, y)

    row = Enum.at(grid, sx)

    number =
      Enum.slice(row, sy..ey)
      |> Enum.join()
      |> String.to_integer()
  end

  def find_number_start(grid, x, y) do
    l = Enum.at(grid, x) |> Enum.at(y - 1)

    if is_nil(l) do
      {x, y}
    else
      case Integer.parse(l) do
        {num, _} -> find_number_start(grid, x, y - 1)
        _ -> {x, y}
      end
    end
  end

  def find_number_end(grid, x, y) do
    r = Enum.at(grid, x) |> Enum.at(y + 1)

    if is_nil(r) do
      {x, y}
    else
      case Integer.parse(r) do
        {num, _} -> find_number_end(grid, x, y + 1)
        _ -> {x, y}
      end
    end
  end

  def find_symbols(grid, symbols) do
    Enum.with_index(grid)
    |> Enum.reduce([], fn {row, x}, acc ->
      Enum.with_index(row)
      |> Enum.reduce(acc, fn {cell, y}, acc2 ->
        if Enum.member?(symbols, Enum.at(grid, x) |> Enum.at(y)) do
          [{x, y}] ++ acc2
        else
          acc2
        end
      end)
    end)
  end

  def find_adjacent_numbers2(grid, x, y) do
    u = {Enum.at(grid, x - 1) |> Enum.at(y), x - 1, y}
    d = {Enum.at(grid, x + 1) |> Enum.at(y), x + 1, y}
    l = {Enum.at(grid, x) |> Enum.at(y - 1), x, y - 1}
    r = {Enum.at(grid, x) |> Enum.at(y + 1), x, y + 1}
    ul = {Enum.at(grid, x - 1) |> Enum.at(y - 1), x - 1, y - 1}
    ur = {Enum.at(grid, x - 1) |> Enum.at(y + 1), x - 1, y + 1}
    dl = {Enum.at(grid, x + 1) |> Enum.at(y - 1), x + 1, y - 1}
    dr = {Enum.at(grid, x + 1) |> Enum.at(y + 1), x + 1, y + 1}

    adj =
      [u, d, l, r, ul, ur, dl, dr]
      |> Enum.reduce([], fn {value, x, y}, acc ->
        Integer.parse(value)
        |> case do
          {num, _} -> acc ++ [get_full_number(grid, x, y)]
          _ -> acc
        end
      end)
      |> Enum.uniq()

    if length(adj) == 2 do
      [a, b] = adj
      a * b
    else
      []
    end
  end

  def part2(args) do
    # args =
    #   "467..114..\n...*......\n..35..633.\n......=...\n617*......\n.....+.58.\n..592.....\n......755.\n...$.*....\n.664.598..\n"

    symbols =
      String.replace(args, ~r/[0-9\n.]/, "")
      |> String.split("", trim: true)
      |> Enum.uniq()

    grid =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn row ->
        String.graphemes(row)
      end)

    symbol_locations = find_symbols(grid, symbols)

    adjacent_numbers =
      symbol_locations
      |> Enum.map(fn {x, y} ->
        find_adjacent_numbers2(grid, x, y)
      end)
      |> List.flatten()
      |> Enum.sum()
  end
end
