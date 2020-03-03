defmodule ElixirKeeb.UIWeb.Keyboard do
  alias ElixirKeeb.UIWeb.Endpoint

  @topic "keyboard"
  @event "keypress"

  def broadcast_keypress(keypress) do
    Endpoint.broadcast(@topic, @event, %{keypress: keypress})
  end
end
