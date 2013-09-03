defmodule Portex.App do
  use Application.Behaviour

  def start(_, _), do: Portex.Sup.start_link(
    Path.join("priv", "echo.py")
  )
  def stop(_), do: :ok
end
