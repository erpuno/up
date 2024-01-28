defmodule UP.Application do
  use Application
  def port, do: Application.get_env(:up, :port, 5010)
  def start(_, _) do
      children = [ { Plug.Cowboy, scheme: :http, plug: UP.Endpoint, options: [port: port()] } ]
      opts = [strategy: :one_for_one, name: App.Supervisor]
      :io.format "UP (Uptime/Status) server listening at port: #{port()}.~n"
      Supervisor.start_link(children, opts)
  end
end
