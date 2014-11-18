import 'dart:async';
import 'dart:html';
import 'dart:js';

import 'package:chrome/chrome_app.dart' as chrome;
import 'test/test_html.dart';

void main() {
  if (context['id'] == 'test') {
    querySelector('#root').remove();
    runHtmlTests();
  }
  else {
    int socket;

    chrome.sockets.udp.create()
      .then((info) => socket = info.socketId)
      .then((_) => chrome.sockets.udp.bind(socket, '0.0.0.0', 21025))
      // .then((_) => chrome.sockets.udp.joinGroup(socket, '224.0.0.1'))
      .then((result) {
        write('Opened UDP socket: ' + (result < 0 ? 'error' : 'success'));
        chrome.sockets.udp.onReceive.listen((packet) {
          write('Received message: ${packet.data}');
        });
      })
      ;

    querySelector('#send-request').onClick.listen(sendRequest);
  }
}

void sendRequest(MouseEvent event) {
  write('Button click detected');
}

void write(String message) {
  querySelector('#logs').appendHtml('<div>$message</div>');
}