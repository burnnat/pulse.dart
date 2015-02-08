library syncthing.bep;

import 'package:chrome/chrome_app.dart' as chrome;
import 'package:chrome_ssl/chrome_ssl.dart';
import 'package:forge/forge.dart';
import 'package:logging/logging.dart';

import 'protocol/bep.dart';
import 'protocol/types.dart';
import 'device.dart';

final Logger logger = new Logger('syncthing.bep');

class BlockSocket extends SslSocket {
  final LocalDevice device;

  int _messageId = 1;

  BlockSocket(this.device) {
    this.onConnect
      .first
      .then((_) {
        _sendMessage(
          new ClusterConfig(
            new XdrString('syncthing.dart'),
            new XdrString('v0.0.1'),
            [],
            []
          )
        );
      });

    this.onData
      .forEach((data) {
        this._handleMessage(data);
      })
      .then((_) {
        this.close();
      });
  }

  String getCertificate(TlsConnection connection, Object hint)
    => device.certPem;

  String getPrivateKey(TlsConnection connection, Certificate cert)
    => device.keyPem;

  void connectToAddress(Address address) {
    connect(address.ip.toString(), address.port.value);
  }

  void _handleMessage(chrome.ArrayBuffer data) {
    BlockMessage message = new BlockMessage.fromBytes(data.getBytes());

    int id = message.id;
    BlockPayload payload = message.payload;

    logger.fine(() => 'Received message $id: $payload');

    if (payload is Ping) {
      _sendMessage(new Pong(), id);
    }
    else if (payload is Close) {
      logger.info(() => 'Remote connection closed with reason: ${payload.reason.value}');
      this.close();
    }
  }

  void _sendMessage(BlockPayload payload, [int id]) {
    if (id == null) {
      id = _messageId++;
    }

    logger.fine(() => 'Sending message $id: $payload');
    this.write(new BlockMessage(id, payload).toBuffer());
  }
}
