defmodule UP.Endpoint do
      use Plug.Router
     plug Plug.Logger
     plug :match
     plug :dispatch
     plug Plug.Parsers, parsers: [:json], json_decoder: Jason
      get "/"  do UP.Service.root(conn) end
      get "/incidents"        do UP.Service.get2(conn,[],[]) end
      get "/incidents/:id"    do UP.Service.get4(conn,[],"incidents",id,"get") end
      put "/incidents"        do UP.Service.put4(conn,[],"incidents",[],"put") end
      get "/maintenance"      do UP.Service.get2(conn,[],[]) end
      get "/maintenance/:id"  do UP.Service.get4(conn,[],"maintenance",id,"get") end
      put "/maintenance"      do UP.Service.put4(conn,[],"maintenance",[],"put") end
      get "/metrics"          do UP.Service.get2(conn,[],[]) end
      get "/metrics/:id"      do UP.Service.get4(conn,[],"metrics",id,"get") end
      put "/metrics"          do UP.Service.put4(conn,[],"metrics",[],"put") end
      get "/components"           do UP.Service.get2(conn,[],[]) end
      get "/components/:type/:id" do UP.Service.get4(conn,[],"components",id,"get") end
      put "/components"           do UP.Service.put4(conn,[],"components",[],"put") end
    match _ do send_resp(conn, 404,
          "Please refer to https://up.erp.uno manual" <>
          " for information about endpoints addresses.") end
end
