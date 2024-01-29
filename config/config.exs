import Config

config :n2o,
  pickler: :n2o_secret,
  app: :up,
  points:
    [{:_, [],
     [{["n2o", :"..."], [], :cowboy_static, {:dir, 'deps/n2o/priv', [{:mimetypes, :cow_mimetypes, :all}]}},
      {["app", :"..."], [], :cowboy_static, {:dir, 'priv',  [{:mimetypes, :cow_mimetypes, :all}]}},
      {["ws",  :"..."], [], :n2o_cowboy,    []} ]}],
  mq: :n2o_syn,
  rest: 5010,
  ws: 5011,
  tables: [:cookies, :file, :caching, :async],
  protocols: [:n2o_heart, :nitro_n2o, :n2o_ftp],
  routes: UP.Route

config :kvs,
  dba: :kvs_rocks,
  dba_st: :kvs_st,
  schema: [:kvs, :kvs_stream, :bpe_metainfo, MED]
