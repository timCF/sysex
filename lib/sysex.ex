defmodule Sysex do
  use Application
  @etop_sorting_params [:runtime, :reductions, :memory, :msg_q]

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sysex.Supervisor]

    [:gc_bytes_trigger, :etop_sort_by]
    |> Stream.map(fn(key) ->
      case Application.get_env(:sysex, key) do
        nil -> nil
        int when (is_integer(int) and (int > 0) and (key == :gc_bytes_trigger)) -> worker(Sysex.GC, [int])
        sorting when ((key == :etop_sort_by) and (sorting in @etop_sorting_params)) -> worker(Sysex.Etop, [sorting])
      end
    end)
    |> Enum.filter(&(&1 != nil))
    |> Supervisor.start_link(opts)
  end

end
