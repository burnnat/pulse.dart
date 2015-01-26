library syncthing.message_discovery;

import 'dart:typed_data';

import 'package:base32/base32.dart';
import 'package:quiver/check.dart';
import 'package:quiver/iterables.dart';

import 'package:syncthing/luhn.dart' as luhn;
import 'package:syncthing/message.dart';
import 'package:syncthing/xdr.dart';

class DiscoveryMessage extends Message {
  final DiscoveryPayload payload;

  const DiscoveryMessage(this.payload);

  static DiscoveryPayload _parsePayload(List<int> raw) {
    List<int> bytes = new List.from(raw);
    Int magic = new Int.fromBytes(bytes.sublist(0, 4));

    if (magic == DiscoveryAnnouncement.MAGIC) {
      return new DiscoveryAnnouncement.fromBytes(bytes);
    }
    else if (magic == DiscoveryQuery.MAGIC) {
      return new DiscoveryQuery.fromBytes(bytes);
    }
    else {
      return null;
    }
  }

  DiscoveryMessage.fromBytes(List<int> bytes) : this(_parsePayload(bytes));

  @override
  ByteBuffer toBuffer() => getPayload().toBuffer();

  @override
  XdrPayload getPayload() => payload;
}

abstract class DiscoveryPayload extends XdrPayload {
  Int magic;

  DiscoveryPayload(this.magic);
  DiscoveryPayload.fromBytes(List<int> bytes) : super.fromBytes(bytes);
}

class DiscoveryQuery extends DiscoveryPayload {
  static const Int MAGIC = const Int(0x2CA856F5);

  DeviceId deviceId;

  DiscoveryQuery(this.deviceId) : super(MAGIC);
  DiscoveryQuery.fromBytes(List<int> bytes) : super.fromBytes(bytes);

  static DiscoveryMessage message(Opaque deviceId)
    => new DiscoveryMessage(new DiscoveryQuery(deviceId));
}

class DiscoveryAnnouncement extends DiscoveryPayload {
  static const Int MAGIC = const Int(0x9D79BC39);

  Device current;
  List<Device> extras;

  DiscoveryAnnouncement(this.current, this.extras) : super(MAGIC);
  DiscoveryAnnouncement.fromBytes(List<int> bytes) : super.fromBytes(bytes);
}

class Device extends XdrPayload {
  DeviceId id;
  List<Address> addresses;

  Device(this.id, this.addresses);
  Device.fromBytes(List<int> bytes) : super.fromBytes(bytes);
}

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

  DeviceId(String id) : super(_decode(id));
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
