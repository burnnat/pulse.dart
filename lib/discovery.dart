library syncthing.discovery;

import 'dart:async';
import 'dart:typed_data';

import 'package:syncthing/message_discovery.dart';
export 'package:syncthing/message_discovery.dart' show DeviceId, Address, IP;
export 'package:syncthing/xdr.dart' show Int;

import 'package:logging/logging.dart';
import 'package:chrome/chrome_app.dart' as chrome;
import 'package:quiver/async.dart';

final Logger logger = new Logger('syncthing.discovery');

abstract class Discoverer {
  Future<Address> locate(DeviceId device);
  void close();
}

class ChainedDiscoverer extends Discoverer {
  final List<Discoverer> _discoverers;

  ChainedDiscoverer(this._discoverers);

  @override
  Future<Address> locate(DeviceId device) {
    Completer<Address> completer = new Completer();

    doWhileAsync(
      _discoverers,
      (discoverer) => discoverer.locate(device)
        .then((address) {
          if (address != null) {
            // We have an address, so stop iterating.
            completer.complete(address);
            return false;
          }
          else {
            // No address found, continue to next discoverer.
            return true;
          }
        })
        // Continue to next discoverer if we run into errors.
        .catchError((e) => true)
    )
    .then((result) {
      if (result) {
        // No discoverers found an address, so return null.
        completer.complete(null);
      }
    });

    return completer.future;
  }

  @override
  void close() {
    _discoverers.forEach((discoverer) => discoverer.close());
  }
}

class ConnectionException implements Exception {
  final int code;

  ConnectionException(int code)
    : this.code = code < 0 ? -code : code;

  @override
  String toString() => 'Connection error: $code';
}

abstract class UdpDiscoverer extends Discoverer {

  final int port;

  int _socket = null;
  Future<bool> _initializing = null;

  UdpDiscoverer(this.port);

  Future<bool> _init() {
    if (_initializing == null) {
      if (_socket != null) {
        // We've already initialized the socket.
        return new Future.value(false);
      }
      else {
        _initializing = _create();
      }
    }

    return _initializing;
  }

  Future<bool> _create() {
    logger.fine('Initializing UDP socket connection');
    return chrome.sockets.udp.create()
      .then((info) {
        _socket = info.socketId;
        return chrome.sockets.udp.bind(_socket, '0.0.0.0', port);
      })
      .then((result) {
        _checkError('Opened UDP socket', result);
        return true;
      });
  }

  Future<int> _send(String remoteAddress, DiscoveryMessage message) {
    chrome.ArrayBuffer data = new chrome.ArrayBuffer.fromBytes(
      new Uint8List.view(message.toBuffer())
    );

    return _init()
      .then((success) => chrome.sockets.udp.send(_socket, data, remoteAddress, port))
      .then((info) {
        _checkError('Sent message data', info.resultCode);
        return info.bytesSent;
      });
  }

  void _checkError(String message, int result) {
    bool hasError = result < 0;
    logger.fine('$message: ' + (hasError ? 'error' : 'success'));

    if (hasError) {
      throw new ConnectionException(result);
    }
  }

  DiscoveryMessage _parseMessage(chrome.ReceiveInfo info) {
    DiscoveryMessage message = new DiscoveryMessage.fromBytes(info.data.getBytes());
    logger.fine('Received message: ${message.payload}');
    return message;
  }

  void close() {
    if (_socket != null) {
      chrome.sockets.udp.close(_socket);
    }
  }
}

class LocalDiscoverer extends UdpDiscoverer {
  static final String _broadcast = '255.255.255.255';

  final Map<DeviceId, List<Address>> _cache = {};

  LocalDiscoverer(int port) : super(port);

  @override
  Future<bool> _create() {
    return super._create()
      .then((created) {
        chrome.sockets.udp.onReceive
          .listen((packet) => _onReceive(_parseMessage(packet)));

        return created;
      });
  }

  void _onReceive(DiscoveryMessage message) {
    DiscoveryPayload payload = message.payload;

    if (payload is DiscoveryAnnouncement) {
      List<Device> devices = [payload.current];
      devices.addAll(payload.extras);

      devices.forEach((device) {
        _cache[device.id] = new List.from(device.addresses);
      });
    }
  }

  @override
  Future<Address> locate(DeviceId device) {
    List<Address> matches = _cache[device];
    return new Future.value(matches != null ? matches.first : null);
  }
}

class GlobalDiscoverer extends UdpDiscoverer {
  static const Duration defaultTimeout = const Duration(seconds: 5);

  final String address;
  final Duration timeout;

  GlobalDiscoverer(this.address, int port, { this.timeout: defaultTimeout })
    : super(port);

  @override
  Future<Address> locate(DeviceId device) {
    Future<Address> result =
      _init()
        .then((success) => chrome.sockets.udp.onReceive.first)
        .then((packet) => _parseMessage(packet))
        .then((message) {
          DiscoveryAnnouncement payload = message.payload;
          return payload.current.addresses.first;
        })
        .timeout(timeout, onTimeout: () => null);

    _send(address, new DiscoveryMessage(new DiscoveryQuery(device)));

    return result;
  }
}
