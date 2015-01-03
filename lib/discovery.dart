library pulsefs.discovery;

import 'dart:async';
import 'dart:typed_data';

import 'package:pulsefs/message_discovery.dart';
import 'package:pulsefs/xdr.dart';

import 'package:chrome/chrome_app.dart' as chrome;

typedef void Logger(String message);

abstract class Discoverer {

  String get _address;
  int get _port;

  final Logger write;

  int _socket = null;

  Discoverer(this.write);

  Future<bool> _init() {
    if (_socket != null) {
      return new Future.value(true);
    }
    else {
      write('Initializing UDP socket connection...');

      return chrome.sockets.udp.create()
        .then((info) {
          _socket = info.socketId;
          return chrome.sockets.udp.bind(_socket, '0.0.0.0', _port);
        })
        .then((result) {
          write('Opened UDP socket: ' + (result < 0 ? 'error' : 'success'));
          return result >= 0;
        });
    }
  }

  Future<bool> _send(DiscoveryMessage message) {
    chrome.ArrayBuffer data = new chrome.ArrayBuffer.fromBytes(
      new Uint8List.view(message.toBuffer())
    );

    return chrome.sockets.udp.send(_socket, data, _address, _port)
      .then((info) {
        int result = info.resultCode;
        write('Sent message data: ' + (result < 0 ? 'error' : 'success'));
        return result >= 0;
      });
  }

  void announce() {

  }

  void discover();
}

class LocalDiscoverer extends Discoverer {
  LocalDiscoverer(Logger write) : super(write);

  String get _address => '255.255.255.255'; // '0.0.0.0'
  int get _port => 21025;

  void discover() {
    int socket;

    chrome.sockets.udp.create()
      .then((info) => socket = info.socketId)
      .then((_) => chrome.sockets.udp.bind(socket, _address, _port))
      // .then((_) => chrome.sockets.udp.joinGroup(socket, '224.0.0.1'))
      .then((result) {
        write('Opened UDP socket: ' + (result < 0 ? 'error' : 'success'));
        chrome.sockets.udp.onReceive.listen((packet) {
          write('Received message: ${packet.data}');
        });
      });
  }
}

class GlobalDiscoverer extends Discoverer {
  GlobalDiscoverer(Logger write) : super(write);

  String get _address => 'announce.syncthing.net';
  int get _port => 22026;

  void discover() {
    _init()
      .then((success) {
        chrome.sockets.udp.onReceive.listen((packet) {
          write('Received message: ${packet.data}');
        });

        write('Set up listener.');

        DeviceId id = new DeviceId('MEUFKLW-DSKHAZM-IRZBSBW-U6RE65I-SHLD7AF-VQY2OVU-LYEXABO-F53URAM');

        return _send(
          new DiscoveryMessage(
            new DiscoveryQuery(id)
          )
        );
      });
  }
}