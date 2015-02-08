library syncthing.protocol.discovery;

import 'dart:typed_data';

import 'message.dart';
import 'types.dart';
import 'xdr.dart';

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

  ByteBuffer toBuffer() => payload.toBuffer();
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
