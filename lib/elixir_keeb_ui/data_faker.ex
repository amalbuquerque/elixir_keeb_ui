defmodule ElixirKeeb.UI.DataFaker do
  use GenServer

  @wait_before_more_data_ms 1500

  @impl true
  def init({elem, how_many}) do
    data = 1..how_many
           |> Enum.map(fn _ -> elem end)

    Process.send_after(self(), :more_data, @wait_before_more_data_ms)

    {:ok, %{data: data, max: how_many}}
  end

  @impl true
  def init(length) do
    data = length
           |> random_data()
           |> Enum.reverse()

    Process.send_after(self(), :more_data, @wait_before_more_data_ms)

    {:ok, %{data: data, max: length}}
  end

  @impl true
  def handle_info(:more_data, %{data: data, max: max} = state) do
    Process.send_after(self(), :more_data, @wait_before_more_data_ms)

    state = %{state | data: append_data(data, random_item(), max)}

    {:noreply, state}
  end

  @impl true
  def handle_call({:get, :all}, _from, %{data: data} = state) do
    to_return = Enum.reverse(data)

    {:reply, to_return, state}
  end

  @impl true
  def handle_call({:get, how_many}, _from, %{data: data} = state) when how_many > 0 do
    to_return = data
           |> Enum.take(how_many)
           |> Enum.reverse()

    {:reply, to_return, state}
  end

  @impl true
  def handle_cast({:add, new_item}, %{data: data, max: max} = state) do
    state = %{state | data: append_data(data, new_item, max)}

    {:noreply, state}
  end

  def new([init_arg, options]) do
    new(init_arg, options)
  end

  def new(init_arg, options \\ [name: __MODULE__]) do
    GenServer.start_link(__MODULE__, init_arg, options)
  end

  def get, do: get(__MODULE__)

  def get(how_many) when is_integer(how_many),
    do: get(__MODULE__, how_many)

  def get(server) when is_atom(server) or is_pid(server) do
    GenServer.call(server, {:get, :all})
  end

  def get(server, how_many)
    when (is_atom(server) or is_pid(server)) and is_integer(how_many) do
    GenServer.call(server, {:get, how_many})
  end

  def append(server, new_item) do
    GenServer.cast(server, {:add, new_item})
  end

  def append_random(server) do
    GenServer.cast(server, {:add, random_item()})
  end

  defp append_data(data, new_item, max) when length(data) < max,
    do: [new_item | data]

  defp append_data(data, new_item, max),
    do: [new_item | data]
        |> Enum.take(max)

  defp random_data(length) do
    seed = seed()

    1..length
    |> Enum.map(random_item_fn(seed))
  end

  defp random_item, do: random_item_fn().(0)

  defp random_item_fn(seed \\ nil)

  defp random_item_fn(nil) do
    seed = seed()

    &abs(1 + :math.sin((seed + &1) / 5.0))
  end

  defp random_item_fn(seed),
    do: &abs(1 + :math.sin((seed + &1) / 5.0))

  defp seed do
    System.monotonic_time()
    |> Integer.mod(100)
  end
end
