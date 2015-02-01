library syncthing.device;

import 'dart:async';
import 'dart:js';

import 'package:logging/logging.dart';
import 'package:forge/forge.dart' as forge;
import 'package:chrome/chrome_app.dart' as chrome;

import 'protocol/types.dart';
import 'global.dart';

final Logger logger = new Logger('syncthing.device');

class LocalDevice {
  static const GlobalType<LocalDevice> TYPE = const _LocalDeviceType();

  static const String _ID = 'id';
  static const String _KEY = 'key.pem';
  static const String _CERT = 'cert.pem';
  static const List<String> STORAGE_KEYS = const [_ID, _KEY, _CERT];

  static Future<LocalDevice> fromStorage() {
    LocalDevice device;

    return chrome.storage.local
      .get(STORAGE_KEYS)
      .then((values) {
        if (STORAGE_KEYS.every((key) => values[key] != null)) {
          logger.info('Loading certificate and key from local storage...');

          device = new LocalDevice._fromPem(values[_ID], values[_KEY], values[_CERT]);

          logger.info('Certificate and key successfully loaded.');
        }
        else {
          logger.info('Generating key pair...');
          forge.KeyPair keyPair = forge.pki.rsa.generateKeyPair(bits: 3072);
          forge.PrivateKey key = keyPair.privateKey;

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

          cert.publicKey = keyPair.publicKey;

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

          device = new LocalDevice._fromForge(key, cert);

          return chrome.storage.local.set({
            _ID: device.id.toString(),
            _KEY: device.keyPem,
            _CERT: device.certPem
          });
        }
      })
      .then((_) => logger.info('Device ID: $device'))
      .then((_) => device);
  }

  final DeviceId id;

  final String keyPem;
  final String certPem;

  LocalDevice._fromPem(String deviceId, String keyPem, String certPem)
    : this._(
        new DeviceId(deviceId),
        keyPem,
        certPem
      );

  LocalDevice._fromForge(forge.PrivateKey key, forge.Certificate cert)
    : this._(
        new DeviceId.fromCertificate(cert),
        forge.pki.privateKeyToPem(key),
        forge.pki.certificateToPem(cert)
      );

  LocalDevice._(this.id, this.keyPem, this.certPem);
}

class _LocalDeviceType extends GlobalType {
  static const String _id = 'id';
  static const String _key = 'key';
  static const String _cert = 'cert';

  const _LocalDeviceType();

  LocalDevice fromJs(JsObject object) =>
    object != null
      ? new LocalDevice._fromPem(object[_id], object[_key], object[_cert])
      : null;

  JsObject toJs(LocalDevice device) => new JsObject.jsify({
    _id: device.id.toString(),
    _key: device.keyPem,
    _cert: device.certPem
  });
}