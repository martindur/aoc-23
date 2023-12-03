defmodule Day2 do
  import Enum

  # First part matches any numbers 20+, and second part matches above the limits and color
  @regex ~r/[1-9]\d{2,}|[2-9]\d|1[3-9] red|1[4-9] green|1[5-9] blue/

  def puzzle1 do
    {:ok, body} = File.read("day02_input.txt")

    String.split(body, "\n")
    |> reject(&(&1 == ""))
    |> map(&String.split(&1, ":"))
    |> map(&List.pop_at(&1, 0))
    |> filter(fn { game_id, [rounds] } -> 
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
    |> IO.inspect
  end

end

Day2.puzzle1
