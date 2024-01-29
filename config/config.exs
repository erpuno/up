import Config

config :n2o,
  routes: UP.Route,
  pickler: :n2o_secret,
  mq: :n2o_syn,
  rest: 5010,
  ws: 5011,
  tables: [:cookies, :file, :caching, :async],
  protocols: [:n2o_heart, :nitro_n2o, :n2o_ftp],
  points:
    [{:_, [],
     [{["app", :"..."], [], :cowboy_static, {:dir, 'priv', [{:mimetypes, :cow_mimetypes, :all}]}},
      {["ws",  :"..."], [], :n2o_cowboy, []}]}]

config :kvs,
  dba: :kvs_mnesia,
  dba_st: :kvs_stream,
  schema: [:kvs, :kvs_stream]
