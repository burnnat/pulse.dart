library pulsefs.message_discovery;

import 'dart:typed_data';

import 'package:base32/base32.dart';
import 'package:quiver/check.dart';
import 'package:quiver/iterables.dart';

import 'package:pulsefs/luhn.dart' as luhn;
import 'package:pulsefs/message.dart';
import 'package:pulsefs/xdr.dart';

class DiscoveryMessage extends Message {
  final DiscoveryPayload payload;

  const DiscoveryMessage(this.payload);

  @override
  ByteBuffer toBuffer() => getPayload().toBuffer();

  @override
  XdrPayload getPayload() => payload;
}

abstract class DiscoveryPayload extends XdrPayload {
  final Int magic;

  const DiscoveryPayload(this.magic);
}

class DiscoveryQuery extends DiscoveryPayload {
  static const Int MAGIC = const Int(0x2CA856F5);

  final DeviceId deviceId;

  const DiscoveryQuery(this.deviceId) : super(MAGIC);

  static DiscoveryMessage message(Opaque deviceId)
    => new DiscoveryMessage(new DiscoveryQuery(deviceId));
}

class DiscoveryAnnouncement extends DiscoveryPayload {
  static const Int MAGIC = const Int(0x9D79BC39);

  final Device current;
  final List<Device> extras;

  const DiscoveryAnnouncement(this.current, this.extras) : super(MAGIC);
}

class Device extends XdrPayload {
  final DeviceId id;
  final List<Address> addresses;

  const Device(this.id, this.addresses);
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
}

class Address extends XdrPayload {
  final Opaque ip;
  final Int port;

  const Address(this.ip, this.port);
}