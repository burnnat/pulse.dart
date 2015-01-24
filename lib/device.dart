library pulsefs.device;

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:forge/forge.dart' as forge;
import 'package:chrome/chrome_app.dart' as chrome;

final Logger logger = new Logger('pulsefs.device');

class LocalDevice {

  static final String _KEY = 'key.pem';
  static final String _CERT = 'cert.pem';

  static Future<LocalDevice> fromStorage() {
    forge.PrivateKey key;
    forge.Certificate cert;

    return chrome.storage.local
      .get(['key.pem', 'cert.pem'])
      .then((values) {
        if (values[_KEY] != null && values[_CERT] != null) {
          key = forge.pki.privateKeyFromPem(values[_KEY]);
          cert = forge.pki.certificateFromPem(values[_CERT]);
        }
        else {
          logger.info('Generating key pair...');
          forge.KeyPair keys = forge.pki.rsa.generateKeyPair(bits: 3072);
          key = keys.privateKey;

          logger.info('Generating certificate...');
          cert = forge.pki.createCertificate();

          cert.serialNumber = '0';

          cert.validity.notBefore = new DateTime.now();
          cert.validity.notAfter = new DateTime(2049, 12, 31, 23, 59, 59);

          List<forge.CertAttribute> attrs = [
            new forge.CertAttribute.withFullName('CN', 'syncthing')
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

          return chrome.storage.local.set({
            _KEY: forge.pki.privateKeyToPem(key),
            _CERT: forge.pki.certificateToPem(cert)
          });
        }
      })
      .then((_) => new LocalDevice(key, cert));
  }

  final forge.PrivateKey key;
  final forge.Certificate cert;

  LocalDevice(this.key, this.cert);
}