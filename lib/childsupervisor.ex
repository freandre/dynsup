defmodule ChildSupervisor do
  # Automatically defines child_spec/1
  use Supervisor

  def child_spec([name]) do
    %{
      id: String.to_atom("Supervisor-" <> name),
      start: {ChildSupervisor, :start_link, [name]},
      type: :supervisor,
      restart: :transient
    }
  end

  def start_link(name) do
    Supervisor.start_link(__MODULE__, name, name: String.to_atom("Supervisor-" <> name))
  end

  @impl true
  def init(name) do
    children = [
      {Child, [String.to_atom(name)]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
