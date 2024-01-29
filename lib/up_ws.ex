defmodule UP.WS do
  require N2O
  def finish(state, ctx), do: {:ok, state, ctx}
  def init(state, context) do
      %{path: path} = N2O.cx(context, :req)
      {:ok, state, N2O.cx(context, path: path, module: __MODULE__)}
  end
  def event(:init), do: :io.format 'NITRO INIT~n'
  def event(x),     do: :io.format 'MESSAGE ~p~n', [x] # > direct(tuple(atom('ok'),number(2)))
end
