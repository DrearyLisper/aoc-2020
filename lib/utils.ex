defmodule Utils do

  def read_input(day) do
    {:ok, content} = File.read("lib/#{day}/input.txt");
    content
  end

  def read_test(day) do
    {:ok, content} = File.read("lib/#{day}/test.txt");
    content
  end

end
