library pulse.message_discovery_test;

import 'dart:typed_data';

import 'package:pulsefs/message_discovery.dart';
import 'package:pulsefs/xdr.dart';
import 'package:unittest/unittest.dart';

void runTests() {

  String idString = 'P56IOI7-MZJNU2Y-IQGDREY-DM2MGTI-MGL3BXN-PQ6W5BM-TBBZ4TJ-XZWICQ2';

  List<int> idBytes = [
    // Length header
    0x00, 0x00, 0x00, 0x20,
    // ID data
    0x7F, 0x7C, 0x87, 0x23,
    0xEC, 0xCA, 0x5B, 0x4D,
    0x22, 0x06, 0x1C, 0x49,
    0x81, 0xB3, 0x4C, 0x34,
    0xD8, 0x65, 0xEC, 0x37,
    0x6B, 0xE1, 0xEB, 0x74,
    0x33, 0x08, 0x73, 0xC9,
    0xA6, 0xF9, 0xB2, 0x05
  ];

  group('Device ID', () {
    test('serializes from human-readable format', () {
      DeviceId id = new DeviceId(idString);
      expect(id.toBytes(), equals(idBytes));
    });

    test('deserializes to human-readable format', () {
      DeviceId id = new DeviceId.fromBytes(idBytes);
      expect(id.toString(), equals(idString));
    });
  });

  group('Announcement message', () {
    String idString2 = 'MFZWI3D-BONSGYC-YLTMRWG-C43ENR5-QXGZDMM-FZWI3DP-BONSGYY-LTMRWAD';
    String idString3 = 'LV5DSJB-GENFCGJ-4TFM5TS-UNCWMJZ-3HCMTYK-RTS6PKO-RLYVCW3-HI3QVAE';

    List<int> serialized = [
      // Magic number
      0x9D, 0x79, 0xBC, 0x39
    ];

    // Device
    serialized.addAll(idBytes);
    serialized.addAll([
      // Addresses length header
      0x00, 0x00, 0x00, 0x02,
      // Address #1
      // IP length header
      0x00, 0x00, 0x00, 0x00,
      // Port
      0x00, 0x00, 0x55, 0xF0, // port 22000
      // Address #2
      // IP length header
      0x00, 0x00, 0x00, 0x04,
      // IP address
      0x08, 0x08, 0x08, 0x08, // 8.8.8.8
      // Port
      0x00, 0x00, 0x55, 0xF1, // port 22001
    ]);

    // Extras
    serialized.addAll([
      // Extras length header
      0x00, 0x00, 0x00, 0x02,

      // Extra device #1
      // Device ID length header
      0x00, 0x00, 0x00, 0x20,
      // Device ID data
      0x61, 0x73, 0x64, 0x6C,
      0x61, 0x73, 0x64, 0x6C,
      0x61, 0x73, 0x64, 0x6C,
      0x61, 0x73, 0x64, 0x6C,
      0x61, 0x73, 0x64, 0x6C,
      0x61, 0x73, 0x64, 0x6C,
      0x61, 0x73, 0x64, 0x6C,
      0x61, 0x73, 0x64, 0x6C,
      // Addresses length header
      0x00, 0x00, 0x00, 0x00,

      // Extra device #2
      // Device ID length header
      0x00, 0x00, 0x00, 0x20,
      // Device ID data
      0x5D, 0x7A, 0x39, 0x24,
      0x26, 0x23, 0x4A, 0x23,
      0x72, 0x65, 0x67, 0x67,
      0x2A, 0x34, 0x56, 0x62,
      0x76, 0x71, 0x32, 0x78,
      0x54, 0x67, 0x2F, 0x3D,
      0x51, 0x5E, 0x2A, 0x2B,
      0x6C, 0xE8, 0xDC, 0x2A,
      // Addresses length header
      0x00, 0x00, 0x00, 0x01,
      // Address #1
      // IP length header
      0x00, 0x00, 0x00, 0x04,
      // IP address
      0xC0, 0xA8, 0x01, 0xC8, // 192.168.1.200
      // Port
      0x00, 0x00, 0x55, 0xF0, // port 22000
    ]);

    test('can serialize to buffer', () {
      DiscoveryMessage message = new DiscoveryMessage(
        new DiscoveryAnnouncement(
          new Device(
            new DeviceId(idString),
            [
              new Address(IP.AUTO, new Int(22000)),
              new Address(new IP.v4('8.8.8.8'), new Int(22001))
            ]
          ),
          [
            new Device(
              new DeviceId(idString2),
              []
            ),
            new Device(
              new DeviceId(idString3),
              [
                new Address(new IP.v4('192.168.1.200'), new Int(22000))
              ]
            )
          ]
        )
      );

      Uint8List data = new Uint8List.view(message.toBuffer());
      expect(data, equals(serialized));
    });

    test('can deserialize from buffer', () {
      DiscoveryMessage message = new DiscoveryMessage.fromBytes(serialized);
      DiscoveryPayload payload = message.payload;
      expect(payload, isNotNull);
      expect(payload, new isInstanceOf<DiscoveryAnnouncement>());

      DiscoveryAnnouncement announcement = payload as DiscoveryAnnouncement;

      Device device = announcement.current;
      List<Address> addresses = device.addresses;
      expect(device.id.toString(), equals(idString));
      expect(addresses.length, equals(2));

      Address address = addresses[0];
      expect(address.ip, equals(IP.AUTO));
      expect(address.port.value, equals(22000));

      address = addresses[1];
      expect(address.ip, equals(new IP.v4('8.8.8.8')));
      expect(address.port.value, equals(22001));

      List<Device> extras = announcement.extras;
      expect(extras.length, equals(2));

      device = extras[0];
      addresses = device.addresses;
      expect(device.id.toString(), equals(idString2));
      expect(addresses, isEmpty);

      device = extras[1];
      addresses = device.addresses;
      expect(device.id.toString(), equals(idString3));
      expect(addresses.length, equals(1));

      address = addresses[0];
      expect(address.ip, equals(new IP.v4('192.168.1.200')));
      expect(address.port.value, equals(22000));
    });
  });

  group('Query message', () {
    List<int> serialized = [
      // Magic number
      0x2C, 0xA8, 0x56, 0xF5
    ];

    serialized.addAll(idBytes);

    test('can serialize to buffer', () {
      DiscoveryMessage message = new DiscoveryMessage(
        new DiscoveryQuery(
          new DeviceId(idString)
        )
      );

      Uint8List data = new Uint8List.view(message.toBuffer());
      expect(data, equals(serialized));
    });

    test('can deserialize from buffer', () {
      DiscoveryMessage message = new DiscoveryMessage.fromBytes(serialized);
      DiscoveryPayload payload = message.payload;
      expect(payload, isNotNull);
      expect(payload, new isInstanceOf<DiscoveryQuery>());

      DiscoveryQuery query = payload as DiscoveryQuery;
      expect(query.deviceId.toString(), equals(idString));
    });
  });
}
