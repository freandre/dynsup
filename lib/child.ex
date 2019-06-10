defmodule Child do
  use GenServer

  def child_spec([name]) do
    %{
      id: name,
      start: {Child, :start_link, [name]},
      type: :worker,
      restart: :permanent
    }
  end

  # Client

  def start_link(name) do
    IO.puts("Start child #{name}")
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  def crash_kill(pid) do
    GenServer.cast(pid, :crash)
  end

  # Server (callbacks)

  @impl true
  def init(:ok) do
    {:ok, []}
  end

  @impl true
  def handle_cast(:crash, state) do
    %{"key" => false}
    |> Enum.map(fn {key, %{} = val} ->
      {key, val}
    end)

    {:noreply, state}
  end
end
