library pulsefs.device;

import 'dart:async';
import 'dart:js';

import 'package:logging/logging.dart';
import 'package:forge/forge.dart' as forge;
import 'package:chrome/chrome_app.dart' as chrome;

import 'global.dart';

final Logger logger = new Logger('pulsefs.device');

class LocalDevice extends Global<LocalDevice> {

  static GlobalType<LocalDevice> TYPE = new _LocalDeviceType();
  GlobalType<LocalDevice> get type => TYPE;

  static final String _KEY = 'key.pem';
  static final String _CERT = 'cert.pem';

  static Future<LocalDevice> fromStorage() {
    String keyPem;
    String certPem;

    return chrome.storage.local
      .get(['key.pem', 'cert.pem'])
      .then((values) {
        if (values[_KEY] != null && values[_CERT] != null) {
          logger.info('Loading certificate and key from local storage...');
          keyPem = values[_KEY];
          certPem = values[_CERT];
          logger.info('Certificate and key successfully loaded.');
        }
        else {
          logger.info('Generating key pair...');
          forge.KeyPair keys = forge.pki.rsa.generateKeyPair(bits: 3072);
          forge.PrivateKey key = keys.privateKey;

          logger.info('Generating certificate...');
          forge.Certificate cert = forge.pki.createCertificate();

          cert.serialNumber = '0';

          cert.validity.notBefore = new DateTime.now();
          cert.validity.notAfter = new DateTime(2049, 12, 31, 23, 59, 59);

          List<forge.CertAttribute> attrs = [
            new forge.CertAttribute.withShortName('CN', 'syncthing')
          ];

          cert.setSubject(attrs);
          cert.setIssuer(attrs);

          cert.publicKey = keys.publicKey;

          cert.setExtensions([
            {
              'name': 'keyUsage',
              'digitalSignature': true,
              'keyEncipherment': true
            },
            {
              'name': 'extKeyUsage',
              'serverAuth': true,
              'clientAuth': true
            },
            {
              'name': 'basicConstraints',
              'cA': false
            }
          ]);

          cert.sign(key);
          logger.info('Certificate generated successfully.');

          keyPem = forge.pki.privateKeyToPem(key);
          certPem = forge.pki.certificateToPem(cert);

          return chrome.storage.local.set({
            _KEY: keyPem,
            _CERT: certPem
          });
        }
      })
      .then((_) => new LocalDevice._(keyPem, certPem));
  }

  final String keyPem;
  final String certPem;

  LocalDevice._(this.keyPem, this.certPem);
}

class _LocalDeviceType extends GlobalType {
  static final String _key = 'key';
  static final String _cert = 'cert';

  LocalDevice fromJs(JsObject object) => new LocalDevice._(object[_key], object[_cert]);

  JsObject toJs(LocalDevice device) => new JsObject.jsify({
    _key: device.keyPem,
    _cert: device.certPem
  });
}