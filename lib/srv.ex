defmodule Portex.Srv do
  @moduledoc """
  Realy stupid OTP-compatible synchronous port server in Elixir
  feed it with \n-terminated strings, please.
  """
  use GenServer.Behaviour

  defrecordp :state, [port: nil]

  @spec call(binary) :: binary
  def call(message) do
    :gen_server.call(__MODULE__, {:call, sanitize(message)})
  end

  def handle_call({:call, message}, _from, state) do
    port = state(state, :port)
    Port.command(port, message)
    case receive_data(port) do
      {:data, data} -> {:reply, data, state}
      :timeout      -> {:stop, :port_timeout, state}
    end
  end

  def terminate(_, state) do
    Port.close(state(state, :port))
    :ok
  end

  def start_link(bin) do
    :gen_server.start_link({:local, __MODULE__}, __MODULE__, [bin], [])
  end
  
  def init([bin]) do
    {:ok, state(port: 
      Port.open({:spawn, String.to_char_list!(bin)}, [:binary, {:line, 1024}])
    )}
  end

  # private
  defp sanitize(message) do
    message = String.replace(message, "\n", "")
    <<message :: binary, "\n">>
  end

  defp receive_data(port), do: receive_data(port, <<>>, <<>>)
  defp receive_data(port, data, line) do
    receive do
      {port, {:data, {:eol, "COMMIT"}}} -> {:data, data}
      {port, {:data, {:eol, rest}}}     -> receive_data(port, <<data :: binary, 
                                                                line :: binary, 
                                                                rest :: binary>>, <<>>)
      {port, {:data, {:noeol, chunk}}}  -> receive_data(port, data, <<line  :: binary, 
                                                                      chunk :: binary>>)
    after
      10000 -> :timeout
    end
  end
end
