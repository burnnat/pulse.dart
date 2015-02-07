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
            new XdrString('0.0.1'),
            [],
            []
          )
        );
      });

    this.onData
      .forEach((data) {
        _parseMessage(data);
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

  BlockPayload _parseMessage(chrome.ArrayBuffer data) {
    BlockMessage message = new BlockMessage.fromBytes(data.getBytes());
    logger.fine('Received message ${message.id}: ${message.payload.toString()}');
    return message.payload;
  }

  void _sendMessage(BlockPayload payload) {
    logger.fine('Sending message ${_messageId}: ${payload.toString()}');
    this.write(new BlockMessage(_messageId++, payload).toBuffer());
  }
}
