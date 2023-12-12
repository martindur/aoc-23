defmodule Day5 do

  defp lookup(map, source) do
    found =
      map
      |> Enum.filter(fn {_, _, source_range} ->
        source in source_range
      end)
      |> List.first

    case found do
      {source_start, dest_start, source_range} -> dest_start + (source - source_start)
      _ -> source
    end
  end

  defp parse_map([_, lookup]) do
    lookup
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn numbers ->
      [destination, source, range] = numbers |> String.split |> Enum.map(&String.to_integer/1)

      #{source, destination, source..(source + range)}
      source..(source + range)
    end)
  end

  def parse(input) do
    input
      |> String.split("\n\n", trim: true)
      |> Enum.with_index
      |> Enum.map(fn {item, index} ->
        case index do
          0 -> String.split(item, ": ") |> then(fn [_, seeds] -> 
              seeds |> String.split |> Enum.map(&String.to_integer/1)
            end)
          _ -> String.split(item, " map:") |> parse_map
        end
      end)
  end

  def puzzle1 do
    {:ok, input} = File.read("day05_input.txt")

    [seeds | maps] = parse(input)

    seeds
    |> Enum.map(fn seed ->
      maps
      |> Enum.reduce(seed, fn map, acc ->
        lookup(map, acc)
      end)
      #|> IO.inspect
      end)
    |> Enum.min
    |> IO.inspect
  end

  defp check_map(map1, map2) do
  end

  def check_overlap(l1, l2) do
    Enum.filter(l2, fn range2 ->
      Enum.any?(l1, fn range1 -> !Range.disjoint?(range1, range2) end)
    end)
  end

  def puzzle2 do
    {:ok, input} = File.read("day05_input_sample.txt")

    [seeds | maps] = parse(input)

    seeds =
      seeds
        |> Enum.chunk_every(2)
        |> Enum.map(fn [val, len] -> val..(val + len) end)
        |> IO.inspect

    maps = List.insert_at(maps, 0, seeds)

    maps
      |> Enum.reverse
      |> IO.inspect
      |> Enum.reduce(fn range_list, acc ->
        acc = check_overlap(acc, range_list)
      end)
      |> IO.inspect
  end

end

#Day5.puzzle1
Day5.puzzle2
