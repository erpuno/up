defmodule UP do
  require KVS
  require Record

  def usr(), do: "41848148"

  @schema [ :account, :site, :subscription, :incident, :maintenance, :component ]

  Enum.each(@schema,
    fn t ->
      Enum.each(
        Record.extract_all(
          from_lib: "up/include/" <> :erlang.list_to_binary(:erlang.atom_to_list(t)) <> ".hrl"
        ),
        fn {name, definition} ->
          prev = :application.get_env(:kernel, :up_tables, [])
          prev2 = :application.get_env(:up, :up_fields, [])
          case :lists.member(name, prev) do
            true ->
              :skip

            false ->
              Record.defrecord(name, definition)
              :application.set_env(:kernel, :up_tables, [name | prev])
              :application.set_env(:up, :up_fields, [{name,definition} | prev2])
          end
        end
      )
    end
  )

   def boot() do
   end

   def metainfo(), do: KVS.schema( name: :up, tables: up_tables())

   def table(name) do
       up_fields = :application.get_env(:up, :up_fields, [])
       {a,b} = :lists.unzip(:proplists.get_value(name, up_fields, []))
       KVS.table(name: name, fields: a, instance: b)
   end

   def up_tables(), do: :lists.map(fn x -> table(x) end, @schema)


end
