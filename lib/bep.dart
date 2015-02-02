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

  BlockSocket(this.device) {
    this.onData
      .forEach((data) {
        logger.info(data);
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

  BlockMessage _parseMessage(chrome.ArrayBuffer data) {
    BlockMessage message = new BlockMessage.fromBytes(data.getBytes());
    logger.fine('Received message: ${message.payload}');
    return message;
  }
}
