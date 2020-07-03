# ElixirKeeb.UI

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Set the `Mix` env as `local`, since it will allow you to use a dummy layout (check the `lib/elixir_keeb_ui_web/keyboard.ex`)
  * Start Phoenix endpoint with `MIX_ENV=local mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

To broadcast keypresses and log messages, check the `broadcast_keypress/1`, `broadcast_keydown/1`, `broadcast_keyup/1` and `broadcast_log_message/1` functions in the `keyboard.ex` file.
