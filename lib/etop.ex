defmodule Sysex.Etop do
  use GenServer
  require Logger
  @ttl 1000

  def start_link(sorting) do
    GenServer.start_link(__MODULE__, [
      node: node(),
      accumulate: true,
      lines: 10,
      interval: 5,
      sort: sorting,
      tracing: :off
    ])
  end
  def init(opts), do: {:ok, opts, @ttl}

  def handle_info(:timeout, opts) do
    _ = Logger.info("Sysex.Etop : init with settings #{ inspect(opts) }")
    _ = :etop.start(opts)
    {:noreply, opts, @ttl}
  end

end
