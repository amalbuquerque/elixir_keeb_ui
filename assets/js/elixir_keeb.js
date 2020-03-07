import Keyboard from "simple-keyboard";
import "simple-keyboard/build/css/index.css";

import socket_and_channel from "./socket";
const {channel} = socket_and_channel;

channel
  .on("keypress", keypress => { console.log("Keypress", keypress) })

channel
  .push("get_layout", {})
  .receive("ok", ({layout}) => {
    let keyboard = new Keyboard({
      onChange: input => onChange(input),
      onKeyPress: button => onKeyPress(button),
      layout: layout
    });

    console.log("Keyboard", keyboard);
  })

/**
 * Update simple-keyboard when input is changed directly
 */
document.querySelector(".input").addEventListener("input", event => {
  keyboard.setInput(event.target.value);
});

function onChange(input) {
  document.querySelector(".input").value = input;
  console.log("Input changed", input);
}

function onKeyPress(button) {
  console.log("Button pressed", button);

  /**
   * If you want to handle the shift and caps lock buttons
   */
  if (button === "{shift}" || button === "{lock}") handleShift();
}

function handleShift() {
  let currentLayout = keyboard.options.layoutName;
  let shiftToggle = currentLayout === "default" ? "shift" : "default";

  keyboard.setOptions({
    layoutName: shiftToggle
  });
}
