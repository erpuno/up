defmodule UP.NITRO do
  def event(:init) do
      :io.format 'NITRO'
  end
  def event(_), do: []
end

