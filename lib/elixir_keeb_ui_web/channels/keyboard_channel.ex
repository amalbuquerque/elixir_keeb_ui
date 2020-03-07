defmodule ElixirKeeb.UIWeb.Channels.KeyboardChannel do
  use ElixirKeeb.UIWeb, :channel
  require Logger

  def join("keyboard", _auth, socket) do
    Logger.info("Receiving connection from client")

    {:ok, socket}
  end

  def handle_in("get_layout", _params, socket) do
    layout = ElixirKeeb.UIWeb.Keyboard.current_layout()

    {:reply, {:ok, %{"layout" => layout}}, socket}
  end
end
