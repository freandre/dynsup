defmodule ChildMgr do
  use GenServer

  # Client

  def start_link(_arg) do
    IO.puts("Start child manager")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def setup do
    ["foo", "bar", "babar", "foobar"]
    |> Enum.each(fn name ->
      add_child(name)
    end)
  end

  def add_child(name) do
    GenServer.cast(__MODULE__, {:child, name})
  end

  def crash_all do
    GenServer.cast(__MODULE__, :crash)
  end

  # Server (callbacks)

  @impl true
  def init(:ok) do
    Process.monitor(DynSup)
    {:ok, []}
  end

  def handle_cast({:child, name}, state) do
    name = String.to_atom(name)
    DynSup.start_child(name)

    {:noreply, [name | state]}
  end

  @impl true
  def handle_cast(:crash, state) do
    state
    |> Enum.each(fn name ->
      Child.crash_kill(name)
    end)

    {:noreply, state}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, {DynSup, _node} = object, _reason}, state) do
    Process.sleep(500)

    Process.monitor(object)

    state
    |> Enum.each(fn name ->
      DynSup.start_child(name)
    end)

    {:noreply, state}
  end

  def handle_info(val, state) do
    IO.inspect(val)

    {:noreply, state}
  end
end
