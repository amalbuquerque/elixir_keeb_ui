defmodule ElixirKeeb.UIWeb.Contex.BarchartTimer do
  use Phoenix.LiveView
  use Phoenix.HTML

  import ElixirKeeb.UIWeb.Contex.Shared

  alias Contex.{BarChart, Plot, Dataset}
  alias ElixirKeeb.UI.DataFaker

  @wait_before_new_data_ms 100
  @plot_dimensions {500, 400}
  @values_range {0, 2.0}
  @head_title "A cool example"

  @initial_options %{
    # number of columns
    categories: 50,
    series: 1,
    orientation: :vertical,
    show_selected: "no",
    title: nil,
    type: :stacked,
    colour_scheme: "themed"
  }

  def render(assigns) do
    ~L"""
      <h3><%= @head_title %></h3>
      <div class="container">
        <div class="row">
          <div class="column column-75">
            <%= if @show_chart do %>
              <%= basic_plot(@test_data, @chart_options) %>
              <%= list_to_comma_string(@chart_options[:friendly_message]) %>
            <% end %>
          </div>
        </div>
      </div>
    """

  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(head_title: @head_title)
      |> assign(chart_options: @initial_options)
      |> get_data()

    socket = case connected?(socket) do
      true ->
        Process.send_after(self(), :tick, @wait_before_new_data_ms)

        assign(socket, show_chart: true)
      false ->
        assign(socket, show_chart: true)
    end

    {:ok, socket}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, @wait_before_new_data_ms)

    {:noreply, get_data(socket)}
  end

  def basic_plot(test_data, chart_options) do
    plot_content = BarChart.new(test_data)
      |> BarChart.set_val_col_names(chart_options.series_columns)
      |> BarChart.type(chart_options.type)
      |> BarChart.orientation(chart_options.orientation)
      |> BarChart.colours(lookup_colours(chart_options.colour_scheme))
      |> BarChart.force_value_range(@values_range)

    {width, height} = @plot_dimensions

    plot = Plot.new(width, height, plot_content)
      |> Plot.titles(chart_options.title, nil)

    Plot.to_svg(plot)
  end

  defp get_data(socket) do
    options = socket.assigns.chart_options
    series = options.series
    categories = options.categories

    data = raw_data(categories)

    series_cols = for i <- 1..series do
      "Series #{i}"
    end

    options = Map.put(options, :series_columns, series_cols)

    test_data = Dataset.new(data, ["Category" | series_cols])

    assign(socket, test_data: test_data, chart_options: options)
  end

  def raw_data(categories) do
    data = DataFaker.get(Fake.DataSource, categories)

    data
    |> Enum.zip(1..length(data))
    |> Enum.map(fn {val, cat} -> ["#{cat}" | [val]] end)
  end
end
