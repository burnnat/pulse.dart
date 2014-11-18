import 'dart:typed_data';
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

  final String deviceId;

  const DiscoveryQuery(this.deviceId) : super(MAGIC);

  static DiscoveryMessage message(String deviceId)
    => new DiscoveryMessage(new DiscoveryQuery(deviceId));
}

class DiscoveryAnnouncement extends DiscoveryPayload {
  static const Int MAGIC = const Int(0x9D79BC39);

  final Device current;
  final Device extras;

  const DiscoveryAnnouncement(this.current, this.extras) : super(MAGIC);
}

class Device extends XdrPayload {
  final String id;
  final List<Address> addresses;

  const Device(this.id, this.addresses);
}

class Address extends XdrPayload {
  final Opaque ip;
  final Short port;

  const Address(this.ip, this.port);
}