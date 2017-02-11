# Sysex

Some runtime BEAM utils. Example of usage ( config )

```elixir
config :sysex,
  # enable forced garbage collection
  gc_bytes_trigger: 25000000,
  # enable etop ( and set sorting for it )
  etop_sort_by: :msg_q # @type :runtime | :reductions | :memory | :msg_q
```
