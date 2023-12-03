defmodule Day3 do
  import Enum

  defp make_adjacent({[{start, len}], [value], line}) do
    # We don't really care that we'll map to lines under 0 or above max length,
    # as the symbols won't be placed there anyways.
    positions =
      for y <- (line - 1)..(line + 1),
          x <- (start - 1)..(start + len),
          do: {{x, y}, String.to_integer(value)}

    Map.new(positions)
  end
  
  def puzzle1 do
    {:ok, body} = File.read("day03_input.txt")

    # strategy: Build two maps:
    # 1st map: 2d matrix where first key is line number, and second key is adjecent index to a found number.
    # Each adjecent position stores the found number.

    # 2nd map: holds symbol as key and position (index, line number) as value

    # check: for each symbol, does any adjecent position hold a value?

    lookup = String.split(body, "\n", trim: true)
      |> with_index
      |> map(fn {line, index} ->
        positions = Regex.scan(~r/\d{1,}/, line, return: :index)
        values = Regex.scan(~r/\d{1,}/, line)
        indices = List.duplicate(index, length(positions))
        zip(zip(positions, values), indices) |> map(fn {{x, y}, z} -> {x, y, z} end)
      end)
      |> List.flatten
      |> map(&make_adjacent/1)
      |> reduce(%{}, fn adj_map, acc -> 
        Map.merge(acc, adj_map, fn _k, v1, v2 -> v1 + v2 end)
      end)

    String.split(body, "\n", trim: true)
      |> with_index
      |> map(fn {line, index} ->
        symbols = Regex.scan(~r/[^.\d]/, line, return: :index)
        indices = List.duplicate(index, length(symbols))
        zip(symbols, indices) |> map(fn {[{x, _}], y} -> {x, y} end)
      end)
      |> List.flatten
      |> reduce(0, fn x, acc ->
        Map.get(lookup, x, 0) + acc
      end)
      |> IO.inspect
  end
  
  def puzzle2 do
    {:ok, body} = File.read("day03_input.txt")

    lookup = String.split(body, "\n", trim: true)
      |> with_index
      |> map(fn {line, index} ->
        positions = Regex.scan(~r/\d{1,}/, line, return: :index)
        values = Regex.scan(~r/\d{1,}/, line)
        indices = List.duplicate(index, length(positions))
        zip(zip(positions, values), indices) |> map(fn {{x, y}, z} -> {x, y, z} end)
      end)
      |> List.flatten
      |> map(&make_adjacent/1)
      |> reduce(%{}, fn adj_map, acc -> 
        Map.merge(acc, adj_map, fn _k, v1, v2 -> [v1, v2] end)
      end)

    String.split(body, "\n", trim: true)
      |> with_index
      |> map(fn {line, index} ->
        symbols = Regex.scan(~r/\*/, line, return: :index)
        indices = List.duplicate(index, length(symbols))
        zip(symbols, indices) |> map(fn {[{x, _}], y} -> {x, y} end)
      end)
      |> List.flatten
      |> map(&Map.get(lookup, &1, 0))
      |> filter(&is_list/1)
      |> map(fn [x, y] -> x * y end)
      |> sum
      |> IO.inspect

  end
end

#Day3.puzzle1
Day3.puzzle2
