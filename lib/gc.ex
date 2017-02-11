defmodule Sysex.GC do
  use GenServer
  require Logger
  @ttl 1000

  def start_link(limit), do: GenServer.start_link(__MODULE__, limit)
  def init(limit) do
    _ = Logger.info("Sysex.GC : init with process memory limit #{ Integer.to_string(limit) }")
    {:ok, limit, @ttl}
  end

  def handle_info(:timeout, limit) do
    :erlang.processes
    |> Enum.each(fn(pid) ->
      case :erlang.process_info(pid, :memory) do
        {:memory, memory} when (is_integer(memory) and (memory > limit)) ->
          _ = Logger.info("Sysex.GC : #{inspect pid} memory is #{ Integer.to_string(memory) }, limit is #{ Integer.to_string(limit) }, enforce GC !")
          _ = :erlang.garbage_collect(pid)
        _ ->
          _ = :timer.sleep(100)
      end
    end)
    {:noreply, limit, @ttl}
  end

end
