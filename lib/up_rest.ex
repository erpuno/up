defmodule UP.HTTP do
   require UP
   import Plug.Conn
      use Plug.Router
     plug Plug.Logger
     plug :match
     plug :dispatch
     plug Plug.Parsers, parsers: [:json], json_decoder: Jason
      get "/"                     do meta(conn) end
      get "/accounts"             do get3(conn,auth(conn),"accounts",[],"lst") end
      get "/accounts/:id"         do get3(conn,auth(conn),"accounts",id,"get") end
      put "/accounts/"            do put3(conn,auth(conn),"accounts",[],"put") end
      get "/sites"                do get3(conn,auth(conn),"sites",[],"lst") end
      get "/sites/:id"            do get3(conn,auth(conn),"sites",id,"get") end
      put "/sites/"               do put3(conn,auth(conn),"sites",[],"put") end
      get "/incidents"            do get3(conn,auth(conn),"incidents",[],"lst") end
      get "/incidents/:id"        do get3(conn,auth(conn),"incidents",id,"get") end
      put "/incidents"            do put3(conn,auth(conn),"incidents",[],"put") end
      get "/metrics"              do get3(conn,auth(conn),"metrics",[],"lst") end
      get "/metrics/:id"          do get3(conn,auth(conn),"metrics",id,"get") end
      put "/metrics"              do put3(conn,auth(conn),"metrics",[],"put") end
      get "/subscriptions"        do get3(conn,auth(conn),"subscriptions",[],"lst") end
      get "/subscriptions/:id"    do get3(conn,auth(conn),"subscriptions",id,"get") end
      put "/subscriptions"        do put3(conn,auth(conn),"subscriptions",[],"put") end
      get "/maintenance"          do get3(conn,auth(conn),"maintenance",[],"lst") end
      put "/maintenance"          do put3(conn,auth(conn),"maintenance",[],"put") end
      get "/maintenance/:id"      do get3(conn,auth(conn),"maintenance",id,"get") end
      get "/components"           do get3(conn,auth(conn),"components",[],"lst") end
      get "/components/:type/:id" do get3(conn,auth(conn),"components",id,"get") end
      put "/components"           do put3(conn,auth(conn),"components",[],"put") end
    match _ do send_resp(conn, 404, "Please refer to https://up.erp.uno manual " <>
                                    "for information about endpoints addresses.") end

   def shd([]), do: []
   def shd(x), do: hd(x)
   def auth(conn), do: shd (conn |> Plug.Conn.get_req_header("auth"))
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

   def upsertAccount(account, type) do
       requested_id = UP.account(account, :id)
       key = :nitro.to_binary(:kvs.seq([],[]))
       id = case :kvs.get "/#{type}/", "#{requested_id}" do
                 {:ok, account} -> :kvs.delete("/keys/", UP.account(account, :key)) ; requested_id
                 {:error, _}    -> :nitro.to_binary(:kvs.seq([],[])) end
       newAccount = account |> UP.account(id: id) |> UP.account(key: key)
       :kvs.append newAccount, "/accounts/"
       :kvs.append {:ref,key,id}, "/keys/"
       newAccount
   end

   def put3(conn,auth,"accounts" = type,_,spec) do
       secAdmin = :application.get_env :up, :security_admin, "1707126861546831000"
       case auth do
            _ when auth == secAdmin ->
                   {:ok, body, conn} = Plug.Conn.read_body(conn, [])
                   account = upsertAccount(UP.Serial.toRecord(:account, Jason.decode!(body)), type)
                   :io.format 'PUT:/#{type}/#{spec} ~p~n', [account]
                   send_resp(conn, 200,
                       encode([%{ "type" => type,
                                  "id" => UP.account(account, :id),
                                  "spec" => spec}]))
            _ ->   :io.format 'PUT:/#{type} AUTH FAILED: ~p~n', [auth]
                   send_resp(conn, 200,
                       encode([%{ "error" => "Authorization",
                                  "text" => "Security admin key doesn't match." }])) end
       end

   def put3(conn,_,"subscriptions" = type,id,spec) do
       :io.format 'PUT:/#{type}/#{id}/#{spec}', []
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

   def get3(conn, auth, "accounts" = type, [], spec) do
       secAdmin = :application.get_env :up, :security_admin, "1707126861546831000"
       case auth do
            _ when auth == secAdmin ->
                   accounts = :lists.map(fn x -> UP.Serial.fromRecord(x) end, :kvs.all("/#{type}/"))
                   :io.format 'GET:/#{type}/#{spec} LIST ~p', [accounts]
                   send_resp(conn, 200, encode([%{"type" => type, "spec" => spec, "result" => accounts }]))
            _ ->   :io.format 'GET:/#{type} AUTH FAILED: ~p~n', [auth]
                   send_resp(conn, 200,
                       encode([%{ "error" => "Authorization",
                                  "text" => "Security admin key doesn't match." }])) end end

   def get3(conn, auth, type, _, spec) when type == "subscriptions"
                                         or type == "sites"
                                         or type == "incidents"
                                         or type == "components"
                                         or type == "metrics"
                                         or type == "maintenance" do
       case :kvs.get("/keys/", auth) do
            {:ok,{:ref, x, name}} when x == auth ->
                res = :lists.map(fn x -> UP.Serial.fromRecord(x) end, :kvs.all("/#{type}/#{name}/"))
                :io.format 'GET:/#{type}/#{spec} NAME ~p LIST ~p', [name, res]
                send_resp(conn, 200,
                    encode([%{ "type" => type,
                               "spec" => spec,
                               "result" => res }]))
            _ -> :io.format 'GET:/#{type} AUTH FAILED: ~p~n', [auth]
                   send_resp(conn, 200,
                       encode([%{ "error" => "Authorization",
                                  "text" => "Account key doesn't match." }]))
       end end

   # DELETE PATH WAY

   def delete3(conn,_,type,id,spec) do
       :io.format 'DELETE:/#{type}#{id}/#{spec}', []
       send_resp(conn, 200, encode(%{"type" => type, "spec" => spec})) end

   def get1(conn,_,type) do
       :io.format 'GET:/#{type}', []
       send_resp(conn, 200, encode([%{"type" => type, "spec" => "list"}])) end


end
