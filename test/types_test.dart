library syncthing.types_test;

import 'package:syncthing/protocol/types.dart';
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
}
