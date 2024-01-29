defmodule UP.Route do
  require N2O
  require Logger

  def finish(state, ctx), do: {:ok, state, ctx}
  def init(state, context) do
      %{path: path} = N2O.cx(context, :req)
      {:ok, state, N2O.cx(context, path: path, module: ws(path))}
  end

  def ws(_),    do: UP.NITRO
  def route(_), do: UP.NITRO

end
