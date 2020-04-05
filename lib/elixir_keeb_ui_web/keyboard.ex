defmodule ElixirKeeb.UIWeb.Keyboard do
  alias ElixirKeeb.UIWeb.Endpoint

  @topic "keyboard"

  def broadcast_log_message(log_message) do
    Endpoint.broadcast(
      @topic, "log", %{logMessage: log_message})
  end

  def broadcast_keypress(key) do
    Endpoint.broadcast(
      @topic, "keypress", %{key: key})
  end

  def broadcast_keydown(key) do
    Endpoint.broadcast(
      @topic, "keydown", %{key: key})
  end

  def broadcast_keyup(key) do
    Endpoint.broadcast(
      @topic, "keyup", %{key: key})
  end

  if Mix.env() == :local do
    def current_layout() do
      %{
        default: [
          "` a1 b2 3 4 5 6 7 8 9 0 - = {bksp}",
          "{tab} q w e r t y u i o p [ ] \\",
          "{lock} a s d f g h j k l ; ' {enter}",
          "{shift} z x c v b n m , . / {shift}",
          ".com @ {space}"
        ],
        shift: [
          "~ ! 4 # $ % ^ & * ( ) _ + {bksp}",
          "{tab} Q W E R T Y U I O P { } |",
          ~s({lock} A S D F G H J K L : " {enter}),
          "{shift} Z X C V B N M < > ? {shift}",
          ".com @ {space}"
        ]
      }
    end

  else
    def current_layout() do
      {
        representation_module,
        representation_function
      } = Application.get_env(:elixir_keeb_ui, :representation)

      keyboard_layout =
        Application.get_env(:elixir_keeb_ui, :keyboard_layout)

      Kernel.apply(
        representation_module,
        representation_function,
        [keyboard_layout])
    end
  end
end
