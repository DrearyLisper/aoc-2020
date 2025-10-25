defmodule Day01 do
  defmodule Solution do
    use GenServer

    @name __MODULE__

    def start_link(content) do
      GenServer.start_link(@name, content, name: @name)
    end

    def len() do
      GenServer.call(@name, {:len})
    end

    def check(i, j) do
      GenServer.call(@name, {:check_two, i, j})
    end

    def check(i, j, k) do
      GenServer.call(@name, {:check_three, i, j, k})
    end

    defp parse(content) do
      content
      |> String.split("\n")
      |> Enum.map(&Integer.parse(&1))
      |> Enum.map(fn {num, _} -> num end)
    end

    # Implementations
    def init(content) do
      {:ok, parse(content)}
    end

    def handle_call({:check_two, i, j}, _, state) do
      i = Enum.at(state, i)
      j = Enum.at(state, j)

      if i + j == 2020 do
        {:reply, {:ok, i * j}, state}
      else
        {:reply, {:notok}, state}
      end
    end

    def handle_call({:check_three, i, j, k}, _, state) do
      i = Enum.at(state, i)
      j = Enum.at(state, j)
      k = Enum.at(state, k)

      if i + j + k == 2020 do
        {:reply, {:ok, i * j * k}, state}
      else
        {:reply, {:notok}, state}
      end
    end

    def handle_call({:len}, _, state) do
      {:reply, {:ok, length(state)}, state}
    end
  end

  def part1 do
    {:ok, len} = Solution.len()

    for(
      {:ok, x} <-
        for(
          i <- 0..(len - 1),
          j <- 0..(len - 1),
          i < j,
          do: Solution.check(i, j)
        ),
      do: x
    )
    |> List.first()
  end

  def part2 do
    {:ok, len} = Solution.len()

    for(
      {:ok, x} <-
        for(
          i <- 0..(len - 1),
          j <- 0..(len - 1),
          k <- 0..(len - 1),
          i < j,
          j < k,
          do: Solution.check(i, j, k)
        ),
      do: x
    )
    |> List.first()
  end

  def run do
    content = Utils.read_input("01")
    Solution.start_link(content)

    IO.puts(Day01.part1())
    IO.puts(Day01.part2())
  end
end
