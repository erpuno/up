defmodule UP.HTTP do
   import Plug.Conn
      use Plug.Router
     plug Plug.Logger
     plug :match
     plug :dispatch
     plug Plug.Parsers, parsers: [:json], json_decoder: Jason
      get "/" do meta(conn) end
      get "/incidents"        do get1(conn,[],"incidents") end
      get "/incidents/:id"    do get3(conn,[],"incidents",id,"get") end
      put "/incidents"        do put3(conn,[],"incidents",[],"put") end
      get "/maintenance"      do get1(conn,[],"incidents") end
      get "/maintenance/:id"  do get3(conn,[],"maintenance",id,"get") end
      put "/maintenance"      do put3(conn,[],"maintenance",[],"put") end
      get "/metrics"          do get1(conn,[],"incidents") end
      get "/metrics/:id"      do get3(conn,[],"metrics",id,"get") end
      put "/metrics"          do put3(conn,[],"metrics",[],"put") end
      get "/components"           do get1(conn,[],[]) end
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
          "GET /incidents", "GET /incidents/:id", "PUT /incidents",
          "GET /maintenance", "GET /maintenance/:id", "PUT /maintenance",
          "GET /metrics", "GET /metrics/:id", "PUT /metrics",
          "GET /components", "GET /components/:type/:id", "PUT /components"
       ], "version" => "1.0", "uri" => "https://up.erp.uno" }])) end

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

   def get3(conn,_,"incidents" = type,id,spec) do
       :io.format 'GET:/#{type}/#{id}/#{spec}', []
       send_resp(conn, 200, encode([%{"type" => type, "id" => id, "spec" => spec}])) end

   def get3(conn,_,"maintenance" = type,id,spec) do
       :io.format 'GET:/#{type}/#{id}/#{spec}', []
       send_resp(conn, 200, encode([%{"type" => type, "id" => id, "spec" => spec}])) end

   def get3(conn,_,"metrics" = type,id,spec) do
       :io.format 'GET:/#{type}/#{id}/#{spec}', []
       send_resp(conn, 200, encode([%{"type" => type, "id" => id, "spec" => spec}])) end

   def get3(conn,_,"components" = type,id,spec) do
       :io.format 'GET:/#{type}/#{id}/#{spec}', []
       send_resp(conn, 200, encode([%{"type" => type, "id" => id, "spec" => spec}])) end

   def delete3(conn,_,type,id,spec) do
       :io.format 'DELETE:/#{type}#{id}/#{spec}', []
       send_resp(conn, 200, encode(%{"type" => type, "id" => id, "spec" => spec})) end

   def get1(conn,_,type) do
       :io.format 'GET:/#{type}', []
       send_resp(conn, 200, encode([%{"type" => type, "spec" => "list"}])) end


end
