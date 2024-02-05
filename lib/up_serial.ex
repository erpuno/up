defmodule UP.Serial do
  require KVS
  require Record
  require UP

   def toRecord(:account, body) do UP.account(
       id: Map.get(body, "id", []),
       name: Map.get(body, "name", []),
       key: Map.get(body, "key", []),
       sites: :lists.map(fn x -> toRecord(:site, x) end, Map.get(body, "sites", [])),
       state: Map.get(body, "state", []) ) end

   def toRecord(:component, body) do UP.component(
       id: Map.get(body, "id", []),
       name: Map.get(body, "name", []),
       account: Map.get(body, "account", []),
       parent: Map.get(body, "parent", []) ) end

   def toRecord(:subscription, body) do UP.subscription(
       id: Map.get(body, "id", []),
       name: Map.get(body, "name", []),
       endpoint: Map.get(body, "endpoint", []) ) end

   def toRecord(:incident, body) do UP.incident(
       id: Map.get(body, "id", []),
       name: Map.get(body, "name", []),
       component: Map.get(body, "component", []),
       account: Map.get(body, "account", []) ) end

   def toRecord(:maintenance, body) do UP.maintenance(
       id: Map.get(body, "id", []),
       name: Map.get(body, "name", []),
       incident: Map.get(body, "incident", []),
       account: Map.get(body, "account", []) ) end

   def toRecord(:site, body) do UP.site(
       id: Map.get(body, "id", []),
       name: Map.get(body, "name", []),
       account: Map.get(body, "account", []),
       components: :lists.map(fn x -> toRecord(:component,   x) end, Map.get(body, "components", [])),
       incidents:  :lists.map(fn x -> toRecord(:component,   x) end, Map.get(body, "incidents", [])),
       maintenance: :lists.map(fn x -> toRecord(:maintenance, x) end, Map.get(body, "maintenance", [])),
       state: Map.get(body, "state", []) ) end

   def fromRecord(UP.account() = o) do %{
       "id"           => :nitro.to_binary(UP.account(o, :id)),
       "name"         => UP.account(o, :name),
       "key"          => UP.account(o, :key),
       "sites"        => :lists.map(fn x -> fromRecord(x) end, UP.account(o, :sites)) } end

   def fromRecord(UP.subscription() = o) do %{
       "id"           => :nitro.to_binary(UP.subscription(o, :id)),
       "name"         => UP.subscription(o, :name),
       "endpoint"     => UP.subscription(o, :endpoint) } end

   def fromRecord(UP.site() = o) do %{
       "id"           => :nitro.to_binary(UP.site(o, :id)),
       "name"         => UP.site(o, :name),
       "account"      => UP.site(o, :account),
       "components"   => :lists.map(fn x -> fromRecord(x) end, UP.site(o, :components)),
       "incidents"    => :lists.map(fn x -> fromRecord(x) end, UP.site(o, :incidents)),
       "maintenance"  => :lists.map(fn x -> fromRecord(x) end, UP.site(o, :maintenance)) } end

   def fromRecord(UP.component() = o) do %{
       "id"           => :nitro.to_binary(UP.component(o, :id)),
       "name"         => UP.component(o, :name),
       "account"      => UP.component(o, :account),
       "site"         => UP.component(o, :site),
       "parent"       => UP.component(o, :parent) } end

   def fromRecord(UP.incident() = o) do %{
       "id"           => :nitro.to_binary(UP.incident(o, :id)),
       "name"         => UP.incident(o, :name),
       "account"      => UP.incident(o, :account),
       "component"    => UP.incident(o, :component) } end

   def fromRecord(UP.maintenance() = o) do %{
       "id"           => :nitro.to_binary(UP.maintenance(o, :id)),
       "name"         => UP.maintenance(o, :name),
       "account"      => UP.maintenance(o, :account),
       "incident"     => UP.maintenance(o, :incident) } end

end
