library syncthing.protocol.types;

import 'package:base32/base32.dart';
import 'package:forge/forge.dart' as forge;
import 'package:quiver/check.dart';
import 'package:quiver/iterables.dart';

import 'luhn.dart' as luhn;
import 'xdr.dart';

class DeviceId extends Opaque {
  static List<int> _decode(String encoded) {
    String data = partition(encoded.split('-'), 2)
      .map((chunk) {
        String raw = chunk[0] + chunk[1];

        checkArgument(
          luhn.base32.validate(raw),
          message: 'Device ID failed checksum validation.'
        );

        return raw.substring(0, raw.length - 1);
      })
      .reduce((a, b) => a + b);

    return base32.decode(data);
  }

  static List<int> _hash(forge.Certificate cert) {
    forge.Digest hash = forge.md.sha256.create();
    forge.ByteBuffer der = forge.asn1.toDer(forge.pki.certificateToAsn1(cert));

    hash.update(der.getBytes());
    forge.ByteBuffer data = hash.digest();

    return new List.generate(data.length(), (i) => data.getByte());
  }

  DeviceId(String id) : super(_decode(id));
  DeviceId.fromCertificate(forge.Certificate cert) : super(_hash(cert));
  DeviceId.fromBytes(List<int> bytes) : super.fromBytes(bytes);

  @override
  String toString() {
    String s = base32.encode(this.data);

    return [
        s.substring(0, 13),
        s.substring(13, 26),
        s.substring(26, 39),
        s.substring(39, 52)
      ]
      .expand(
        (chunk) => [
          chunk.substring(0, 7),
          chunk.substring(7) + luhn.base32.generate(chunk)
        ]
      )
      .reduce((a, b) => a + '-' + b);
  }
}

class Address extends XdrPayload {
  IP ip;
  Int port;

  Address(this.ip, this.port);
  Address.fromBytes(List<int> bytes) : super.fromBytes(bytes);
}

class IP extends Opaque {
  static final IP AUTO = new IP._auto();

  IP._auto() : super([]);

  static List<int> _decode(String address) {
    return address
      .split('.')
      .map((octet) => int.parse(octet, radix: 10))
      .toList();
  }

  IP.v4(String address) : super(_decode(address));
  IP.fromBytes(List<int> bytes) : super.fromBytes(bytes);

  @override
  String toString() {
    switch (data.length) {
      case 0:
        return 'AUTO';
      case 4:
        // IPv4
        return data.join('.');
      case 16:
        // IPv6
      default:
        return data.toString();
    }
  }
}
