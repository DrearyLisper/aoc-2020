defmodule Day03 do
  def parse(content) do
    String.split(content, "\n")
    |> Enum.map(&String.to_charlist(&1))
  end

  def part1(content) do
    lines = parse(content)

    len = length(List.first(lines))

    tl(lines)
    |> Enum.with_index()
    |> Enum.map(fn {x, i} -> Enum.at(x, rem((i + 1) * 3, len)) end)
    |> Enum.count(&(&1 == ?#))
  end

  def part2(content) do
    lines = parse(content)

    len = length(List.first(lines))

    [
      lines
      |> Enum.with_index()
      |> Enum.map(fn {x, i} ->
        if i != 0 and rem(i, 2) == 0, do: Enum.at(x, rem(div(i, 2), len)), else: ?.
      end)
      |> Enum.count(&(&1 == ?#))
      | [1, 3, 5, 7]
        |> Enum.map(fn j ->
          tl(lines)
          |> Enum.with_index()
          |> Enum.map(fn {x, i} -> Enum.at(x, rem((i + 1) * j, len)) end)
          |> Enum.count(&(&1 == ?#))
        end)
    ]
    |> Enum.product()
  end

  def run do
    content = Utils.read_input("03")

    IO.puts(Day03.part1(content))
    IO.puts(Day03.part2(content))
  end
end
