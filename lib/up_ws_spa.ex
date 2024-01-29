defmodule UP.NITRO do
  def event(:init), do: :io.format 'NITRO INIT~n'
  def event(x),     do: :io.format 'MESSAGE ~p~n', [x] # > direct(tuple(atom('ok'),number(2)))
end

