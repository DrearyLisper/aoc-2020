defmodule Day02 do
  defmodule Solution do
    use GenServer

    @name __MODULE__

    def start_link(content) do
      GenServer.start_link(@name, content, name: @name)
    end

    def len() do
      GenServer.call(@name, {:len})
    end

    def check_frequencies(i) do
      GenServer.call(@name, {:check_frequencies, i})
    end

    def check_positions(i) do
      GenServer.call(@name, {:check_positions, i})
    end

    def parse(content) do
      content
      |> String.split("\n")
      |> Enum.map(
        &Regex.named_captures(
          ~r/(?<from>\d+)-(?<to>\d+) (?<letter>[a-z]): (?<password>[a-z]+)/,
          &1
        )
      )
      |> Enum.map(fn %{"from" => from, "to" => to, "letter" => letter, "password" => password} ->
        %{
          :from => Integer.parse(from) |> then(fn {i, _} -> i end),
          :to => Integer.parse(to) |> then(fn {i, _} -> i end),
          :letter => List.first(String.to_charlist(letter)),
          :password => String.to_charlist(password),
          :frequencies => Enum.frequencies(String.to_charlist(password))
        }
      end)
    end

    # Implementations
    def init(content) do
      {:ok, parse(content)}
    end

    def handle_call({:check_frequencies, i}, _, state) do
      %{
        :from => from,
        :to => to,
        :letter => letter,
        :frequencies => frequencies
      } = Enum.at(state, i)

      frequency = frequencies[letter]

      if frequency != nil and frequency >= from and frequency <= to do
        {:reply, {:ok, i}, state}
      else
        {:reply, {:notok}, state}
      end
    end

    def handle_call({:check_positions, i}, _, state) do
      %{
        :from => from,
        :to => to,
        :letter => letter,
        :password => password
      } = Enum.at(state, i)

      if (Enum.at(password, from - 1) == letter && Enum.at(password, to - 1) != letter) or
           (Enum.at(password, from - 1) != letter && Enum.at(password, to - 1) == letter) do
        {:reply, {:ok, i}, state}
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
      i <- 0..(len - 1),
      do: Solution.check_frequencies(i)
    )
    |> then(&for {:ok, x} <- &1, do: x)
    |> length()
  end

  def part2 do
    {:ok, len} = Solution.len()

    for(
      i <- 0..(len - 1),
      do: Solution.check_positions(i)
    )
    |> then(&for {:ok, x} <- &1, do: x)
    |> length()
  end

  def run do
    content = Utils.read_input("02")
    Solution.start_link(content)

    IO.puts(Day02.part1())
    IO.puts(Day02.part2())
  end
end
