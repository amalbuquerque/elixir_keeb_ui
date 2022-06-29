defmodule ElixirKeeb.UIWeb.Router do
  use ElixirKeeb.UIWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :liveview do
    plug :put_root_layout, {ElixirKeeb.UIWeb.LayoutView, :app}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElixirKeeb.UIWeb do
    pipe_through :browser

    live "/matrix_scan_latency", MatrixScanLatencyBarchart
    live "/matrix_to_usb_latency", MatrixToUsbLatencyBarchart

    get "/", PageController, :index
    get "/logs", PageController, :logs
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElixirKeeb.UIWeb do
  #   pipe_through :api
  # end
end
