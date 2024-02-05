defmodule UP.Instatus do
  def verify(), do: {:ssl, [{:verify, :verify_none}]}
  @endpoint (:application.get_env(:mrs, :endpoint, "https://api.instatus.com")) # upstream
  def reduceGet(url, name, pageRequested, count, acc) do
      bearer = :application.get_env(:up, :instatus, '')
      accept = 'application/json'
      headers = [{'Authorization',bearer},{'accept',accept}]
      addr = '#{@endpoint}#{url}?page=#{pageRequested}&per_page=#{count}'
      {:ok,{{_,status,_},_headers,body}} =
         :httpc.request(:get, {addr, headers},
           [{:timeout,100000},verify()], [{:body_format,:binary}])
      case status do
           _ when status >= 100 and status < 200 -> :io.format 'WebSockets not supported: ~p', [body] ; acc
           _ when status >= 500 and status < 600 -> :io.format 'Fatal Error: ~p',              [body] ; acc
           _ when status >= 400 and status < 500 -> :io.format 'Resource not available: ~p',   [addr] ; acc
           _ when status >= 300 and status < 400 -> :io.format 'Go away: ~p',                  [body] ; acc
           _ when status >= 200 and status < 300 ->
                  :io.format '#{name}: ~p~n', [{body}]
                  Jason.decode!(body)
      end
  end

  def pages(),            do: reduceGet("/v2/pages",                     "pages",         1, 100, [])
  def components(page),   do: reduceGet("/v1/#{page}/components",        "components",    1, 100, [])
  def component(page,id), do: reduceGet("/v1/#{page}/components/#{id}",  "component",     1, 100, [])

end

