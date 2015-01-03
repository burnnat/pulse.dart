library pulsefs.ssl_socket;

import 'dart:async';
import 'dart:typed_data';

import 'package:chrome/chrome_app.dart' as chrome;
import 'package:forge/forge.dart' as forge;

String _fromBuffer(ByteBuffer buffer) {
  Uint16List data = new Uint16List.view(buffer);
  return new String.fromCharCodes(data.toList());
}

ByteBuffer _fromString(String string) {
  List<int> data = string.codeUnits;
  return new Uint16List.fromList(data).buffer;
}

abstract class SslSocket implements forge.TlsHandler {
  int _socketId;
  forge.TlsConnection _tls;

  final List<StreamController> _streams;
  final List<StreamSubscription> _subscriptions;

  StreamController _connectStream;
  Stream get onConnect => _connectStream.stream;

  StreamController _dataStream;
  Stream get onData => _dataStream.stream;

  StreamController _drainStream;
  Stream get onDrain => _drainStream.stream;

  StreamController _makeController() {
    StreamController controller = new StreamController();
    _streams.add(controller);
    return controller;
  }

  SslSocket() :
      _streams = [],
      _subscriptions = [] {

    _connectStream = _makeController();
    _dataStream = _makeController();
    _drainStream = _makeController();
  }

  void _active() {
    // reset timeout ...
  }

  void connect(String host, int port) {
    _active();

    chrome.sockets.tcp.create()
      .then((info) {
        _socketId = info.socketId;

        if (_socketId > 0) {
          chrome.sockets.tcp.setPaused(_socketId, true);
          chrome.sockets.tcp.connect(_socketId, host, port)
            .then(_onConnect);
        }
        else {
          _emitError('Unable to create socket');
        }
      });
  }

  void _onConnect(int status) {
    if (status < 0) {
      _emitChromeError('Unable to connect to socket', status);
      return;
    }

    _initializeTls();
    _tls.handshake(null);

    _subscriptions.add(
      chrome.sockets.tcp.onReceive.listen(this._onReceive)
    );
    _subscriptions.add(
      chrome.sockets.tcp.onReceiveError.listen(this._onReceiveError)
    );
    chrome.sockets.tcp.setPaused(_socketId, false);
  }

  void _emit(StreamController controller, [dynamic value]) {
    if (!controller.isPaused && !controller.isClosed) {
      controller.add(value);
    }
  }

  void _emitChromeError(String message, int code) {
    String chromeMessage;

    if (chrome.runtime.lastError != null) {
      chromeMessage = chrome.runtime.lastError.message;
    }

    _emitError('${message}: ${chromeMessage} (error ${-code})');
  }

  void _emitError(String message) {
    print('Error: $message');
  }

  void _initializeTls() {
    _tls = forge.tls.createConnection(this);
  }

  void close() {
    if (_tls != null) {
      _tls.close();
    }
  }

  void _close() {
    if (_socketId != null) {
      _subscriptions
        ..forEach((subscription) {
          subscription.cancel();
        })
        ..clear();

      chrome.sockets.tcp
        ..disconnect(_socketId)
        ..close(_socketId);
    }

    _streams.forEach((controller) {
      controller.close();
    });
  }

  void write(ByteBuffer data) {
    _tls.prepare(_fromBuffer(data));
  }

  void _onReceive(chrome.ReceiveInfo info) {
    if (info.socketId != _socketId) {
      return;
    }

    _active();

    if (!_tls.open) {
      return;
    }

    _tls.process(_fromBuffer(info.data as ByteBuffer));
  }

  void _onReceiveError(chrome.ReceiveErrorInfo info) {
    if (info.socketId != _socketId) {
      return;
    }

    _active();

    if (info.resultCode == -100) {
      // Connection closed.
    }
    else {
      _emitChromeError('Read from socket', info.resultCode);
    }

    _close();
  }

  bool verify(
    forge.TlsConnection connection,
    bool verified,
    int depth,
    List<forge.Certificate> chain
  ) => true;

  void heartbeatReceived(
    forge.TlsConnection connection,
    forge.ByteBuffer payload
  ) {}

  void connected(forge.TlsConnection connection) {
    _emit(_connectStream);
  }

  void tlsDataReady(forge.TlsConnection connection) {
    forge.ByteBuffer data = connection.tlsData;

    // Use dynamic to avoid warning assigning ByteBuffer to ArrayBuffer
    dynamic buffer = _fromString(data.getBytes());

    chrome.sockets.tcp.send(_socketId, buffer)
      .then((info) {
        int resultCode = info.resultCode;

        if (resultCode < 0) {
          _emitChromeError('Socket error on write', resultCode);
        }

        int sent = info.bytesSent;
        int total = data.length();

        if (sent == total) {
          _emit(_drainStream);
        }
        else {
          if (sent > 0) {
            _emitError('Incomplete write: wrote $sent of $total bytes');
          }

          _emitError('Invalid write on socket: code $resultCode');
        }
      });
  }

  void dataReady(forge.TlsConnection connection) {
    _emit(_dataStream, _fromString(connection.data.getBytes()));
  }

  void closed(forge.TlsConnection connection) {
    _close();
  }

  void error(forge.TlsConnection connection, forge.TlsError error) {
    _emitError('TLS error: ${error.message}');
    _close();
  }
}
