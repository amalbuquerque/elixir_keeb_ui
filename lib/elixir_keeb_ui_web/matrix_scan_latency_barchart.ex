defmodule ElixirKeeb.UIWeb.MatrixScanLatencyBarchart do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias ElixirKeeb.UIWeb.Contex.BarchartTimer

  @chart_options Application.get_env(:elixir_keeb_ui, :barcharts)[:matrix_scan_latency]

  def render(assigns) do
    BarchartTimer.render(assigns)
  end

  def mount(params, session, socket) do
    params = case is_map(params) do
      true ->
        Map.put(params, :initial_options, @chart_options)

      _ ->
        %{initial_options: @chart_options}
    end

    BarchartTimer.mount(params, session, socket)
  end

  def handle_info(:tick, socket) do
    BarchartTimer.handle_info(:tick, socket)
  end
end
