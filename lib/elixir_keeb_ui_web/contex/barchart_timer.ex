defmodule ElixirKeeb.UIWeb.Contex.BarchartTimer do
  use Phoenix.LiveView
  use Phoenix.HTML

  import ElixirKeeb.UIWeb.Contex.Shared

  alias Contex.{BarChart, Plot, Dataset}

  def render(assigns) do
    ~L"""
      <div class="container">
        <div class="row">
          <div class="column column-75">
            <%= if @show_chart do %>
              <%= basic_plot(@chart_data, @chart_options) %>
            <% end %>
          </div>
        </div>
      </div>
    """
  end

  def mount(params, _session, socket) do
    initial_options = case params[:initial_options] do
      nil ->
        raise("`initial_options` used for the barchart need to be passed through the `params` argument. Params passed: #{inspect(params)}")

      options when is_map(options) ->
        options
    end

    socket =
      socket
      |> assign(chart_options: initial_options)
      |> get_data()

    wait_before_new_data_ms =
      initial_options.data_source[:wait_before_new_data_ms]

    socket = case connected?(socket) do
      true ->
        Process.send_after(self(), :tick, wait_before_new_data_ms)

        assign(socket, show_chart: true)
      false ->
        assign(socket, show_chart: true)
    end

    {:ok, socket}
  end

  def handle_info(:tick, socket) do
    wait_before_new_data_ms =
      socket.assigns.chart_options.data_source[:wait_before_new_data_ms]

    Process.send_after(self(), :tick, wait_before_new_data_ms)

    {:noreply, get_data(socket)}
  end

  def basic_plot(chart_data, chart_options) do
    plot_content = BarChart.new(chart_data)
      |> BarChart.set_val_col_names(chart_options.series_columns)
      |> BarChart.type(chart_options.type)
      |> BarChart.orientation(chart_options.orientation)
      |> BarChart.colours(lookup_colours(chart_options.colour_scheme))
      |> BarChart.force_value_range(chart_options.values_range)

    {width, height} = chart_options.plot_dimensions

    plot = Plot.new(width, height, plot_content)
      |> Plot.titles(chart_options.title, nil)

    Plot.to_svg(plot)
  end

  defp get_data(socket) do
    options = socket.assigns.chart_options
    series = options.series

    data = raw_data(options.data_source[:mfa])

    series_cols = for i <- 1..series do
      "Series #{i}"
    end

    options = Map.put(options, :series_columns, series_cols)

    chart_data = Dataset.new(data, ["Category" | series_cols])

    assign(socket, chart_data: chart_data, chart_options: options)
  end

  def raw_data({module, function, args}) when is_list(args) do
    data = Kernel.apply(module, function, args)

    data
    |> Enum.zip(1..length(data))
    |> Enum.map(fn {val, cat} -> ["#{cat}" | [val]] end)
  end
end
