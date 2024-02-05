defmodule UP.HTTP do
   require UP
   import Plug.Conn
      use Plug.Router
     plug Plug.Logger
     plug :match
     plug :dispatch
     plug Plug.Parsers, parsers: [:json], json_decoder: Jason
      get "/"                     do meta(conn) end
      get "/accounts"             do get3(conn,[],"accounts",[],"lst") end
      get "/accounts/:id"         do get3(conn,[],"accounts",id,"get") end
      put "/accounts/:id"         do put3(conn,[],"accounts",id,"put") end
      get "/incidents"            do get3(conn,[],"incidents",[],"lst") end
      get "/incidents/:id"        do get3(conn,[],"incidents",id,"get") end
      put "/incidents"            do put3(conn,[],"incidents",[],"put") end
      get "/metrics"              do get3(conn,[],"metrics",[],"lst") end
      get "/metrics/:id"          do get3(conn,[],"metrics",id,"get") end
      put "/metrics"              do put3(conn,[],"metrics",[],"put") end
      get "/subscriptions"        do get3(conn,[],"subscriptions",[],"lst") end
      get "/subscriptions/:id"    do get3(conn,[],"subscriptions",id,"get") end
      put "/subscriptions"        do put3(conn,[],"subscriptions",[],"put") end
      get "/maintenance"          do get3(conn,[],"maintenance",[],"lst") end
      put "/maintenance"          do put3(conn,[],"maintenance",[],"put") end
      get "/maintenance/:id"      do get3(conn,[],"maintenance",id,"get") end
      get "/components"           do get3(conn,[],"components",[],"lst") end
      get "/components/:type/:id" do get3(conn,[],"components",id,"get") end
      put "/components"           do put3(conn,[],"components",[],"put") end
    match _ do send_resp(conn, 404, "Please refer to https://up.erp.uno manual " <>
                                    "for information about endpoints addresses.") end

   def encode(x) do
       case  Jason.encode(x) do
             {:ok, bin} -> bin <> "\n"
             _ -> "ERROR" <> "\n"
       end |> Jason.Formatter.pretty_print
   end

   def meta(conn) do
       :io.format 'UP/$meta', []
       conn |> Plug.Conn.put_resp_content_type("application/json") |>
       send_resp(200, encode([%{ "resourceType" => "UP", "methods" => [
          "GET /accounts", "GET /accounts/:id", "PUT /accounts",
          "GET /subscriptions", "GET /subscriptions/:id", "PUT /subscriptions",
          "GET /incidents", "GET /incidents/:id", "PUT /incidents",
          "GET /maintenance", "GET /maintenance/:id", "PUT /maintenance",
          "GET /metrics", "GET /metrics/:id", "PUT /metrics",
          "GET /components", "GET /components/:type/:id", "PUT /components"
       ], "version" => "1.0", "uri" => "https://up.erp.uno" }])) end

   # PUT PATHWAY

   def put3(conn,_,"subscriptions" = type,id,spec) do
       :io.format 'PUT:/#{type}/#{id}/#{spec}', []
       send_resp(conn, 200, encode([%{"type" => type, "id" => id, "spec" => spec}])) end

   def put3(conn,_,"accounts" = type,id,spec) do
       {:ok, body, conn} = Plug.Conn.read_body(conn, [])
       account = UP.Serial.toRecord(:account, Jason.decode!(body))
       :io.format 'PUT:/#{type}/#{id}/#{spec} ~p~n', [account]
       :kvs.append account, "/accounts/"
       id = UP.account(account, :id)
       send_resp(conn, 200, encode([%{"type" => type, "id" => id, "spec" => spec}])) end

   def put3(conn,_,"incidents" = type,id,spec) do
       :io.format 'PUT:/#{type}/#{id}/#{spec}', []
       send_resp(conn, 200, encode([%{"type" => type, "id" => id, "spec" => spec}])) end

   def put3(conn,_,"maintenance" = type,id,spec) do
       :io.format 'PUT:/#{type}/#{id}/#{spec}', []
       send_resp(conn, 200, encode([%{"type" => type, "id" => id, "spec" => spec}])) end

   def put3(conn,_,"metrics" = type,id,spec) do
       :io.format 'PUT.3:/#{type}/#{id}/#{spec}', []
       send_resp(conn, 200, encode([%{"type" => type, "id" => id, "spec" => spec}])) end

   def put3(conn,_,"components" = type,id,spec) do
       :io.format 'PUT.3:/#{type}/#{id}/#{spec}', []
       send_resp(conn, 200, encode([%{"type" => type, "id" => id, "spec" => spec}])) end

   # GET LIST PATHWAY

   def get3(conn,_,"subscriptions" = type,id,spec) do
       :io.format 'GET:/#{type}/#{id}/#{spec}', []
       send_resp(conn, 200, encode([%{"type" => type, "id" => id, "spec" => spec}])) end

   def get3(conn,_,"accounts" = type,[],spec) do
       accounts = :lists.map(fn x -> UP.Serial.fromRecord(x) end, :kvs.all("/#{type}/"))
       :io.format 'GET:/#{type}/#{spec} LIST ~p', [accounts]
       send_resp(conn, 200, encode([%{"type" => type, "spec" => spec, "result" => accounts }])) end

   def get3(conn,_,"accounts" = type,id,spec) do
       {:ok, account} = :kvs.get "/#{type}/", "#{id}"
       :io.format 'GET:/#{type}/#{id}/#{spec} GET ~p', [account]
       send_resp(conn, 200, encode([%{"type" => type, "spec" => spec, "result" => UP.Serial.fromRecord(account) }])) end

   def get3(conn,_,"incidents" = type,id,spec) do
       :io.format 'GET:/#{type}/#{id}/#{spec}', []
       send_resp(conn, 200, encode([%{"type" => type, "spec" => spec}])) end

   def get3(conn,_,"maintenance" = type,id,spec) do
       :io.format 'GET:/#{type}/#{id}/#{spec}', []
       send_resp(conn, 200, encode([%{"type" => type, "spec" => spec}])) end

   def get3(conn,_,"metrics" = type,id,spec) do
       :io.format 'GET:/#{type}/#{id}/#{spec}', []
       send_resp(conn, 200, encode([%{"type" => type, "spec" => spec}])) end

   def get3(conn,_,"components" = type,id,spec) do
       :io.format 'GET:/#{type}/#{id}/#{spec}', []
       send_resp(conn, 200, encode([%{"type" => type, "spec" => spec}])) end

   # DELETE PATH WAY

   def delete3(conn,_,type,id,spec) do
       :io.format 'DELETE:/#{type}#{id}/#{spec}', []
       send_resp(conn, 200, encode(%{"type" => type, "spec" => spec})) end

   def get1(conn,_,type) do
       :io.format 'GET:/#{type}', []
       send_resp(conn, 200, encode([%{"type" => type, "spec" => "list"}])) end


end
