defmodule Portex.Sup do
  use Supervisor.Behaviour

  def init(bin) do
    tree = [ worker(Portex.Srv, bin) ]
    supervise(tree, strategy: :one_for_one)
  end

  def start_link(bin) do
    :supervisor.start_link({:local, __MODULE__}, __MODULE__, [bin])
  end
end
