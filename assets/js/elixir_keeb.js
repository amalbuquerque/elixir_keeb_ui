import Keyboard from 'simple-keyboard';
import 'simple-keyboard/build/css/index.css';

import socket_and_channel from './socket';
const {channel} = socket_and_channel;

const keyboard_event = (type, key) => {
  return new KeyboardEvent(type, {
    'key': key,
    'bubbles': true,
  });
};

const handleShift = (keyboard) => {
  let currentLayout = keyboard.options.layoutName;
  let shiftToggle = currentLayout === 'default' ? 'shift' : 'default';

  keyboard.setOptions({
    layoutName: shiftToggle
  });
};

const getButtonElement = (keyboard, event) => {
  let layoutKeyName = keyboard.physicalKeyboard.getSimpleKeyboardLayoutKey(
    event
  );

  const buttonElement =
    keyboard.getButtonElement(layoutKeyName) ||
    keyboard.getButtonElement(`{${layoutKeyName}}`);

  if (!buttonElement) {
    console.log("Could not find button in layout", layoutKeyName);

    return null;
  }

  if (Array.isArray(buttonElement)) {
    return buttonElement[0];
  }

  return buttonElement;
};

const highlightButtonFunc = (keyboard) => {
  return (event) => {
    const buttonElement = getButtonElement(keyboard, event);

    if (!buttonElement) {
      return false;
    }

    buttonElement.style.background = "#9ab4d0";
    buttonElement.style.color = "white";
  };
}

const unhighlightButtonFunc = (keyboard) => {
  return (event) => {
    const buttonElement = getButtonElement(keyboard, event);

    if (!buttonElement) {
      return false;
    }

    buttonElement.removeAttribute("style");
  };
};

const set_channel_handlers = (keyboard, channel) => {
  const highlightButton = highlightButtonFunc(keyboard);
  const unhighlightButton = unhighlightButtonFunc(keyboard);

  channel
    .on('keypress', ({key}) => {
      console.log('Keypress', key);

      event = keyboard_event('keydown', key);
      highlightButton(event);

      setTimeout(() => {
        event = keyboard_event('keyup', key);
        unhighlightButton(event);
      }, 50)
    });

  channel
    .on('keydown', ({key}) => {
      console.log('Key down', key);

      if(key === "shift") {
        handleShift(keyboard);
      }

      event = keyboard_event('keydown', key);
      highlightButton(event);
    });

  channel
    .on('keyup', ({key}) => {
      console.log('Key up', key);

      if(key === "shift") {
        handleShift(keyboard);
      }

      event = keyboard_event('keyup', key);
      unhighlightButton(event);
    });
};

const configureKeyboard = (layout) => {
  const onChange = (input) => {
    document.querySelector('.input').value = input;
    console.log('Input changed', input);
  };

  const onKeyPress = (button) => {
    console.log('Button pressed', button);
  };

  let keyboard = new Keyboard({
    newLineOnEnter: true,
    tabCharOnTab: true,
    physicalKeyboardHighlight: true,
    debug: true,
    onChange: input => onChange(input),
    onKeyPress: input => onKeyPress(input),
    layout: layout
  });

  console.log('Keyboard', keyboard);

  /**
   * Update simple-keyboard when input is changed directly
   */
  document.querySelector('.input').addEventListener('input', event => {
    keyboard.setInput(event.target.value);
  });

  return keyboard;
};

channel
  .push('get_layout', {})
  .receive('ok', ({layout}) => {
    let keyboard = configureKeyboard(layout);

    set_channel_handlers(keyboard, channel);
  });
