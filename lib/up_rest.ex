defmodule UP.HTTP do
   require UP
   import Plug.Conn
      use Plug.Router
#    plug Plug.Logger
     plug :match
     plug :dispatch
     plug Plug.Parsers, parsers: [:json], json_decoder: Jason

      get "/"             do meta(conn) end
      get "/account"      do get3(conn,auth(conn),"account",[],"lst") end
      get "/account/:id"  do get3(conn,auth(conn),"account",id,"get") end
      put "/account/"     do put3(conn,auth(conn),"account",[],"put") end
      get "/:type"        do get3(conn,auth(conn),type,[],"lst") end
      get "/:type/:id"    do get3(conn,auth(conn),type,id,"get") end
      put "/:type/:id"    do put3(conn,auth(conn),type,id,"put") end
      delete "/:type/:id" do delete3(conn,auth(conn),type,id,"del") end

   def shd([]), do: []
   def shd(x), do: hd(x)
   def auth(conn), do: shd (conn |> Plug.Conn.get_req_header("auth"))
   def encode(x) do
       case  Jason.encode(x) do
             {:ok, bin} -> bin <> "\n"
             _ -> encode([%{ "error" => "format" }])
       end |> Jason.Formatter.pretty_print
   end

   def meta(conn) do
       :io.format 'UP/$meta', []
       conn |> Plug.Conn.put_resp_content_type("application/json") |>
       send_resp(200, encode([%{ "resourceType" => "UP", "methods" => [
          "GET /account", "GET /accounts/:id", "PUT /account",
          "GET /subscription", "GET /subscription/:id", "PUT /subscription/:id",
          "GET /incident", "GET /incidents/:id", "PUT /incidents/:id",
          "GET /maintenance", "GET /maintenance/:id", "PUT /maintenance/:id",
          "GET /metric", "GET /metric/:id", "PUT /metric/:id",
          "GET /component", "GET /component/:id", "PUT /component/:id"
       ], "version" => "1.0", "uri" => "https://up.erp.uno" }])) end

   # PUT PATHWAY

   def upsertAccount(account, type) do
       requested_id = UP.account(account, :id)
       key = :nitro.to_binary(:kvs.seq([],[]))
       id = case :kvs.get "/#{type}/", "#{requested_id}" do
                 {:ok, account} -> :kvs.delete("/keys", UP.account(account, :key)) ; requested_id
                 {:error, _}    -> :nitro.to_binary(:kvs.seq([],[])) end
       newAccount = account |> UP.account(id: id) |> UP.account(key: key)
       :kvs.append newAccount, "/account/"
       :kvs.append {:ref,key,id}, "/keys"
       newAccount
   end

   def put3(conn, auth, type, id, spec) when type == "account" do
       secAdmin = :application.get_env :up, :security_admin, :nitro.to_binary(:kvs.seq([],[]))
       case auth do
            _ when auth == secAdmin ->
                   {:ok, body, conn} = Plug.Conn.read_body(conn, [])
                   map = Jason.decode!(body)
                   case :kvs.get("/account", Map.get(map, "id", [])) do
                        {:ok, UP.account()} ->
                           send_resp(conn, 400,
                           encode([%{ "error" => "Alreasy exists",
                                      "id" => id,
                                      "text" => "You may want to delete it before update or force put with headers." }]))
                        _ ->
                           account = upsertAccount(UP.Serial.toRecord(:account, map), type)
                           :io.format 'PUT:/#{type}/#{spec} ~p~n', [account]
                           send_resp(conn, 200,
                           encode([%{ "type" => type,
                                      "id" => UP.account(account, :id),
                                      "spec" => spec }]))
                   end
            _ ->   :io.format 'PUT:/#{type} SEC AUTH FAILED: ~p~n', [auth]
                   send_resp(conn, 400,
                       encode([%{ "error" => "Authorization",
                                  "text" => "Security admin key doesn't match." }])) end end

   def put3(conn, auth, type, id, spec) when type == "subscription"
                                          or type == "site"
                                          or type == "incident"
                                          or type == "component"
                                          or type == "metric"
                                          or type == "maintenance" do
       case :kvs.get("/keys", auth) do
            {:ok,{:ref, x, name}} when x == auth and id == name ->
                 {:ok, body, conn} = Plug.Conn.read_body(conn, [])
                 o = UP.Serial.toRecord(:erlang.binary_to_atom(type), Jason.decode!(body))
                 :io.format 'PUT:/#{type}/#{name}/#{spec} ~p', [o]
                 newObject = o |> UP.component(account: id) |> UP.component(id: :kvs.seq([],[]))
                 :kvs.append newObject, "/#{type}/#{name}"
                 send_resp(conn, 200,
                     encode([%{ "type" => type,
                                "id" => id,
                                "result" => UP.Serial.fromRecord(newObject),
                                "spec" => spec }]))
            _ -> :io.format 'PUT:/#{type} AUTH FAILED: ~p~n', [auth]
                 send_resp(conn, 400,
                     encode([%{ "error" => "Authorization",
                                "text" => "Account key doesn't match." }])) end end

   def put3(conn, _, type, _, _) do
       send_resp(conn, 400,
           encode([%{ "error" => "Method",
                      "text" => "Resource :#{type} not found." }]))
   end

   # GET PATHWAY

   def get3(conn, auth, type, _, spec) when type == "account" do
       secAdmin = :application.get_env :up, :security_admin, :nitro.to_binary(:kvs.seq([],[]))
       case auth do
            _ when auth == secAdmin ->
                   accounts = :lists.map(fn x -> UP.Serial.fromRecord(x) end, :kvs.all("/#{type}"))
                   :io.format 'GET:/#{type}/#{spec} LIST ~p', [accounts]
                   send_resp(conn, 200, encode([%{"type" => type, "spec" => spec, "result" => accounts }]))
            _ ->   :io.format 'GET:/#{type} SEC AUTH FAILED: ~p~n', [auth]
                   send_resp(conn, 400,
                       encode([%{ "error" => "Authorization",
                                  "text" => "Security admin key doesn't match." }])) end end

   def get3(conn, auth, type, _, spec) when type == "subscription"
                                         or type == "site"
                                         or type == "incident"
                                         or type == "component"
                                         or type == "metric"
                                         or type == "maintenance" do
       case :kvs.get("/keys", auth) do
            {:ok,{:ref, x, name}} when x == auth ->
                res = :lists.map(fn x -> UP.Serial.fromRecord(x) end, :kvs.all("/#{type}/#{name}/"))
                :io.format 'GET:/#{type}/#{spec} NAME ~p LIST ~p', [name, res]
                send_resp(conn, 200,
                    encode([%{ "type" => type,
                               "spec" => spec,
                               "result" => res }]))
            _ -> :io.format 'GET:/#{type} AUTH FAILED: ~p~n', [auth]
                   send_resp(conn, 400,
                       encode([%{ "error" => "Authorization",
                                  "text" => "Account key doesn't match." }])) end end

   def get3(conn, _, type, _, _) do
       send_resp(conn, 400,
           encode([%{ "error" => "Method",
                      "text" => "Resource #{type} not found." }]))
   end

   # DELETE PATHWAY

   def delete3(conn, _, type, _, _) do
       send_resp(conn, 400,
           encode([%{ "error" => "Method",
                      "text" => "Resource #{type} not found." }]))
   end

end
