defmodule Portex.Srv do
  use GenServer.Behaviour

  def handle_call({:say, what}, _from, state) do
    {:reply, what, state}
  end

  def start_link(bin) do
    :gen_server.start_link({:local, __MODULE__}, __MODULE__, [bin], [])
  end
  
  def init(_) do
    {:ok, nil}
  end
end
