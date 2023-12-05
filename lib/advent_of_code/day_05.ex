defmodule AdventOfCode.Day05 do
  def part1(args) do
    # args =
    #   "seeds: 79 14 55 13\n\nseed-to-soil map:\n50 98 2\n52 50 48\n\nsoil-to-fertilizer map:\n0 15 37\n37 52 2\n39 0 15\n\nfertilizer-to-water map:\n49 53 8\n0 11 42\n42 0 7\n57 7 4\n\nwater-to-light map:\n88 18 7\n18 25 70\n\nlight-to-temperature map:\n45 77 23\n81 45 19\n68 64 13\n\ntemperature-to-humidity map:\n0 69 1\n1 0 69\n\nhumidity-to-location map:\n60 56 37\n56 93 4\n"

    maps =
      String.split(args, "\n\n", trim: true)
      |> Enum.reduce(%{}, fn chunk, acc ->
        [type, values] = String.split(chunk, ":", trim: true)

        case type do
          "seeds" ->
            seeds =
              String.split(values, " ", trim: true)
              |> Enum.map(&String.to_integer/1)

            Map.put(acc, :seeds, seeds)

          _ ->
            parsed =
              values
              |> String.split("\n", trim: true)
              |> Enum.map(fn line ->
                [destination, source, length] =
                  String.split(line, " ", trim: true)
                  |> Enum.map(&String.to_integer/1)

                {destination, destination + length, source, source + length}
              end)

            type =
              type |> String.replace(" map", "") |> String.replace("-", "_") |> String.to_atom()

            Map.put(
              acc,
              type,
              parsed
            )
        end
      end)

    IO.inspect(maps, label: "maps")

    Map.get(maps, :seeds)
    |> Enum.map(fn seed ->
      IO.inspect(seed, label: "seed")
      soil = find_location(seed, maps.seed_to_soil) |> IO.inspect(label: "soil")
      fertilizer = find_location(soil, maps.soil_to_fertilizer) |> IO.inspect(label: "fertilizer")
      water = find_location(fertilizer, maps.fertilizer_to_water) |> IO.inspect(label: "water")
      light = find_location(water, maps.water_to_light) |> IO.inspect(label: "light")

      temperature =
        find_location(light, maps.light_to_temperature) |> IO.inspect(label: "temperature")

      humidity =
        find_location(temperature, maps.temperature_to_humidity) |> IO.inspect(label: "humidity")

      find_location(humidity, maps.humidity_to_location) |> IO.inspect(label: "location")
    end)
    |> Enum.min()
  end

  def find_location(source, ranges) do
    found =
      Enum.find(ranges, fn {_dest_start, _dest_end, source_start, source_end} ->
        source >= source_start && source <= source_end
      end)

    if is_nil(found) do
      source
    else
      {dest_start, _dest_end, source_start, _source_end} = found

      dif = source - source_start

      dest_start + dif
    end
  end

  def part2(args) do
    # args =
    #   "seeds: 79 14 55 13\n\nseed-to-soil map:\n50 98 2\n52 50 48\n\nsoil-to-fertilizer map:\n0 15 37\n37 52 2\n39 0 15\n\nfertilizer-to-water map:\n49 53 8\n0 11 42\n42 0 7\n57 7 4\n\nwater-to-light map:\n88 18 7\n18 25 70\n\nlight-to-temperature map:\n45 77 23\n81 45 19\n68 64 13\n\ntemperature-to-humidity map:\n0 69 1\n1 0 69\n\nhumidity-to-location map:\n60 56 37\n56 93 4\n"

    maps =
      String.split(args, "\n\n", trim: true)
      |> Enum.reduce(%{}, fn chunk, acc ->
        [type, values] = String.split(chunk, ":", trim: true)

        case type do
          "seeds" ->
            seeds =
              String.split(values, " ", trim: true)
              |> Enum.map(&String.to_integer/1)
              |> Enum.chunk_every(2)
              |> Enum.map(fn [start, length] ->
                {start, start + length}
              end)
              |> List.flatten()

            Map.put(acc, :seeds, seeds)

          _ ->
            parsed =
              values
              |> String.split("\n", trim: true)
              |> Enum.map(fn line ->
                [destination, source, length] =
                  String.split(line, " ", trim: true)
                  |> Enum.map(&String.to_integer/1)

                {destination, destination + length - 1, source, source + length - 1}
              end)

            type =
              type |> String.replace(" map", "") |> String.replace("-", "_") |> String.to_atom()

            Map.put(
              acc,
              type,
              parsed
            )
        end
      end)

    Map.get(maps, :seeds)
    |> Enum.map(fn {seed_start, seed_end} ->
      soil_ranges = find_location2([{seed_start, seed_end}], maps.seed_to_soil, [])
      fertilizer_ranges = find_location2(soil_ranges, maps.soil_to_fertilizer, [])
      water_ranges = find_location2(fertilizer_ranges, maps.fertilizer_to_water, [])
      light_ranges = find_location2(water_ranges, maps.water_to_light, [])
      temperature_ranges = find_location2(light_ranges, maps.light_to_temperature, [])
      humidity_ranges = find_location2(temperature_ranges, maps.temperature_to_humidity, [])
      find_location2(humidity_ranges, maps.humidity_to_location, [])
    end)
    |> List.flatten()
    |> Enum.map(fn {start, _end} ->
      start
    end)
    |> Enum.min()
  end

  def find_location2([], _ranges, new_ranges) do
    new_ranges
  end

  def find_location2([{input_start, input_end} | tails], ranges, new_ranges) do
    found =
      Enum.find(ranges, fn {_dest_start, _dest_end, source_start, source_end} ->
        input_start >= source_start &&
          input_start <= source_end
      end)

    cond do
      is_nil(found) ->
        [{input_start, input_end}] ++ find_location2(tails, ranges, new_ranges)

      true ->
        {dest_start, dest_end, source_start, source_end} = found

        cond do
          input_end <= source_end ->
            dif = input_start - source_start

            [{dest_start + dif, dest_start + dif + (input_end - input_start)}] ++
              find_location2(tails, ranges, new_ranges)

          input_end > source_end ->
            dif = input_start - source_start

            [{dest_start + dif, dest_end}] ++
              find_location2([{source_end + 1, input_end}] ++ tails, ranges, new_ranges)
        end
    end
  end
end
