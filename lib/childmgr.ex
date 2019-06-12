defmodule ChildMgr do
  use Agent

  def start_link(_arg) do
    IO.puts("Start child manager")
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def setup do
    ["foo", "bar", "babar", "foobar"]
    |> Enum.each(fn name ->
      add_child(name)
    end)
  end

  def add_child(name) do
    DynSup.start_child(name)
    Agent.update(__MODULE__, &[name | &1])
  end

  def crash_all do
    Agent.get(__MODULE__, & &1)
    |> Enum.each(fn name ->
      Child.crash_kill(String.to_atom(name))
    end)
  end
end
