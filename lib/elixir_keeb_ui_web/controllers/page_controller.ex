defmodule ElixirKeeb.UIWeb.PageController do
  use ElixirKeeb.UIWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
