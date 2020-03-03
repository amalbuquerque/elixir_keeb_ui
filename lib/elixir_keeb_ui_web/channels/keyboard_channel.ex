defmodule ElixirKeeb.UIWeb.Channels.KeyboardChannel do
  use ElixirKeeb.UIWeb, :channel
  require Logger

  def join("keyboard", _auth, socket) do
    Logger.info("Receiving connection from client")

    {:ok, socket}
  end
end
