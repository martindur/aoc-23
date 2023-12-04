defmodule Day4 do
  import Enum

  defp calculate_points(card_count) do
    case card_count do
      0 -> 0
      _ -> Integer.pow(2, card_count - 1)
    end
  end

  defp parse_cards(input) do
    String.split(input, "\n", trim: true)
    |> map(fn "Card " <> rest ->
      {card_id, ": " <> rest} =
        rest
          |> String.trim
          |> Integer.parse

      [winners, values] =
        rest
        |> String.split(" | ")
        |> map(&Regex.scan(~r/\d{1,}/, &1))
        |> map(&List.flatten/1)

      {card_id, winners, values}
    end)
  end

  def puzzle1 do
    {:ok, input} = File.read("day04_input.txt")

    parse_cards(input)
      |> map(fn {_, winners, values} -> to_list(MapSet.intersection(MapSet.new(winners), MapSet.new(values))) end)
      |> map(&length/1)
      |> map(&calculate_points/1)
      |> sum
      |> IO.inspect
  end

  def puzzle2 do
    {:ok, input} = File.read("day04_input.txt")

    parse_cards(input)
      |> reduce(%{}, fn {card_id, winners, values}, acc ->
        wins = MapSet.intersection(MapSet.new(winners), MapSet.new(values)) |> to_list |> length
        
        {cur, acc} = Map.get_and_update(acc, card_id, fn current_value ->
          case current_value do
            nil -> {1, 1}
            _   -> {current_value + 1, current_value + 1}
          end
        end)

        reduce(1..wins//1, acc, &Map.update(&2, card_id + &1, cur, fn x -> x + cur end))
      end)
      |> Map.values
      |> sum
      |> IO.inspect
  end

end

#Day4.puzzle1
Day4.puzzle2
