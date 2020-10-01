import socket_and_channel from './socket';
const {channel} = socket_and_channel;

channel
  .on('log', ({logMessage}) => {
    let logsTextArea = document.querySelector('.logs');

    logsTextArea.value += (logMessage + '\n');
    logsTextArea.scrollTop = logsTextArea.scrollHeight;
  });
