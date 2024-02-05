defmodule UP.Application do
  use Application
  def rest, do: Application.get_env(:n2o, :rest, 5010)
  def ws, do: Application.get_env(:n2o, :ws, 5011)
  def start(_, _) do
      children = [ { Plug.Cowboy, scheme: :http, plug: UP.HTTP, options: [port: rest()] } ]
      opts = [strategy: :one_for_one, name: App.Supervisor]
      :kvs.join
      :cowboy.start_clear(:http, [{:port, ws()}], %{env: %{dispatch: Application.get_env(:n2o, :points, [])}})
      :io.format "UP UPTIME/STATUS version 1.0.~n"
      :io.format "1: HTTP API listening at port: #{rest()}.~n"
      :io.format "2: WebSocket NITRO listening at port: #{ws()}.~n"
      Supervisor.start_link(children, opts)
  end
end
