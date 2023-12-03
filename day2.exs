defmodule Day2 do
  import Enum

  # First part matches any numbers 20+, and second part matches above the limits and color
  @regex ~r/[1-9]\d{2,}|[2-9]\d|1[3-9] red|1[4-9] green|1[5-9] blue/

  defp get_max_color(values) do
    values
      |> List.flatten
      |> map(&String.replace(&1, ~r/[^\d]/, ""))
      |> reject(&(&1 == ""))
      |> map(&String.to_integer/1)
      |> max
  end

  def puzzle1 do
    {:ok, body} = File.read("day02_input.txt")

    String.split(body, "\n")
    |> reject(&(&1 == ""))
    |> map(&String.split(&1, ":"))
    |> map(&List.pop_at(&1, 0))
    |> filter(fn { _, [rounds] } -> 
      [] == Regex.scan(@regex, rounds)
    end)
    |> map(fn { "Game " <> game_id, _ } ->
      String.to_integer(game_id)
    end)
    |> sum
    |> IO.inspect
  end

  def puzzle2 do
    {:ok, body} = File.read("day02_input.txt")

    String.split(body, "\n")
    |> reject(&(&1 == ""))
    |> map(&String.split(&1, ":"))
    |> map(&List.pop_at(&1, 0))
    |> map(fn { _, [rounds] } -> 
      %{
        "greens" => Regex.scan(~r/\d{1,} green/, rounds),
        "blues" => Regex.scan(~r/\d{1,} blue/, rounds),
        "reds" => Regex.scan(~r/\d{1,} red/, rounds)
      }
    |> IO.inspect
    end)
    |> map(fn %{ "greens" => g, "blues" => b, "reds" => r} ->
      get_max_color(g) * get_max_color(b) * get_max_color(r)
    end)
    |> IO.inspect
    |> sum
    |> IO.inspect
  end

end

#Day2.puzzle1
Day2.puzzle2
