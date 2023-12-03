defmodule Day1 do
  import Enum

  def puzzle1 do
    {:ok, body} = File.read("day01_input.txt")

    String.split(body, "\n")
    |> IO.inspect
    |> map(&String.replace(&1, ~r/[^\d]/, ""))
    |> IO.inspect
    |> map(fn str ->
         cond do
           byte_size(str) < 2 -> str <> str
           true -> String.at(str, 0) <> String.at(str, -1)
         end
       end)
    |> IO.inspect
    |> reject(&(&1 == ""))
    |> map(&String.to_integer/1)
    |> sum
    |> IO.inspect
  end

  defp lookup(word) do
    case word do
      "one" -> "1"
      "two" -> "2"
      "three" -> "3"
      "four" -> "4"
      "five" -> "5"
      "six" -> "6"
      "seven" -> "7"
      "eight" -> "8"
      "nine" -> "9"
      _ -> word
    end
  end

  def puzzle2 do
    {:ok, body} = File.read("day01_input.txt")

    str_re = ~r/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/
    num_re = ~r/[^\d]/

    String.split(body, "\n")
    |> IO.inspect
    |> map(&Regex.scan(str_re, &1))
    |> map(&List.flatten/1)
    |> map(fn sublist ->
        map(sublist, &lookup/1) end)
    |> IO.inspect
    |> map(&List.to_string/1)
    |> IO.inspect
    |> map(fn str ->
         cond do
           byte_size(str) < 2 -> str <> str
           true -> String.at(str, 0) <> String.at(str, -1)
         end
       end)
    |> reject(&(&1 == ""))
    |> map(&String.to_integer/1)
    |> sum
    |> IO.inspect
  end

end

#Day1.puzzle1
Day1.puzzle2
