library syncthing.bep_test;

import 'dart:typed_data';

import 'package:syncthing/protocol/bep.dart';
import 'package:unittest/unittest.dart';

part 'bep_config_test.dart';
part 'bep_index_test.dart';
part 'bep_other_test.dart';

void runTests() {
  group('Block exchange messages', () {
    test('fail on unknown versions', () {
      List<int> serialized = [
        0xD8, 0xC2, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00
      ];

      // Make sure messages can be parsed from immutable lists.
      serialized = new List.from(serialized, growable: false);

      expect(
        () => new BlockMessage.fromBytes(serialized),
        throwsA(new isInstanceOf<UnsupportedVersionError>()),
        reason: 'Did not throw UnsupportedVersionError'
      );
    });

    test('fail on unknown message types', () {
      List<int> serialized = [
        0x08, 0xC2, 0xFF, 0x00,
        0x00, 0x00, 0x00, 0x00
      ];

      // Make sure messages can be parsed from immutable lists.
      serialized = new List.from(serialized, growable: false);

      expect(
        () => new BlockMessage.fromBytes(serialized),
        throwsA(new isInstanceOf<UnknownMessageTypeError>()),
        reason: 'Did not throw UnknownMessageTypeError'
      );
    });
  });

  runConfigTests();
  runIndexTests();
  runOtherTests();
}
