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

    def handle_call({:check_two, i, j}, from, state) do
      spawn(fn ->
        i = Enum.at(state, i)
        j = Enum.at(state, j)

        if i + j == 2020 do
          GenServer.reply(from, {:ok, i * j})
        else
          GenServer.reply(from, {:notok})
        end
      end)

      {:noreply, state}
    end

    def handle_call({:check_three, i, j, k}, from, state) do
      spawn(fn ->
        i = Enum.at(state, i)
        j = Enum.at(state, j)
        k = Enum.at(state, k)

        if i + j + k == 2020 do
          GenServer.reply(from, {:ok, i * j * k})
        else
          GenServer.reply(from, {:notok})
        end
      end)

      {:noreply, state}
    end

    def handle_call({:len}, _, state) do
      {:reply, {:ok, length(state)}, state}
    end
  end

  def part1 do
    {:ok, len} = Solution.len()

    Stream.flat_map(0..(len - 1), fn i ->
      Stream.flat_map(0..(len - 1), fn j ->
        if(i < j, do: [{i, j}], else: [])
      end)
    end)
    |> Task.async_stream(fn {i, j} -> Solution.check(i, j) end, max_concurrency: 128)
    |> then(&for {:ok, {:ok, x}} <- &1, do: x)
    |> List.first()
  end

  def part2 do
    {:ok, len} = Solution.len()

    Stream.flat_map(0..(len - 1), fn i ->
      Stream.flat_map(0..(len - 1), fn j ->
        Stream.flat_map(0..(len - 1), fn k ->
          if(i < j and j < k, do: [{i, j, k}], else: [])
        end)
      end)
    end)
    |> Stream.map(fn {i, j, k} -> Solution.check(i, j, k) end)
    |> then(&for {:ok, x} <- &1, do: x)
    |> List.first()
  end

  def run do
    content = Utils.read_input("01")
    Solution.start_link(content)

    IO.puts(Day01.part1())
    IO.puts(Day01.part2())
  end
end
