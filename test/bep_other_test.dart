part of syncthing.bep_test;

void runOtherTests() {
  group('Ping message', () {
    List<int> serialized = [
      0x08, 0xC2, 0x04, 0x00,
      0x00, 0x00, 0x00, 0x00,
    ];

    // Make sure messages can be parsed from immutable lists.
    serialized = new List.from(serialized, growable: false);

    test('can serialize to buffer', () {
      BlockMessage message = new BlockMessage(0x8C2, new Ping());
      Uint8List data = new Uint8List.view(message.toBuffer());
      expect(data, equals(serialized));
    });

    test('can deserialize from buffer', () {
      BlockMessage message = new BlockMessage.fromBytes(serialized);
      BlockPayload payload = message.payload;
      expect(payload, isNotNull);
      expect(payload, new isInstanceOf<Ping>());
    });
  });

  group('Pong message', () {
    List<int> serialized = [
      0x08, 0xC2, 0x05, 0x00,
      0x00, 0x00, 0x00, 0x00,
    ];

    // Make sure messages can be parsed from immutable lists.
    serialized = new List.from(serialized, growable: false);

    test('can serialize to buffer', () {
      BlockMessage message = new BlockMessage(0x8C2, new Pong());
      Uint8List data = new Uint8List.view(message.toBuffer());
      expect(data, equals(serialized));
    });

    test('can deserialize from buffer', () {
      BlockMessage message = new BlockMessage.fromBytes(serialized);
      BlockPayload payload = message.payload;
      expect(payload, isNotNull);
      expect(payload, new isInstanceOf<Pong>());
    });
  });

  group('Close message', () {
    List<int> serialized = [
      0x08, 0xC2, 0x07, 0x00,
      0x00, 0x00, 0x00, 0x18,

      // Reason length header
      0x00, 0x00, 0x00, 0x13,

      // Reason ("Not enough cowbell!")
      0x4E, 0x6F, 0x74, 0x20,
      0x65, 0x6E, 0x6F, 0x75,
      0x67, 0x68, 0x20, 0x63,
      0x6F, 0x77, 0x62, 0x65,
      0x6C, 0x6C, 0x21, 0x00,
    ];

    // Make sure messages can be parsed from immutable lists.
    serialized = new List.from(serialized, growable: false);

    test('can serialize to buffer', () {
      BlockMessage message = new BlockMessage(
        0x8C2,
        new Close(
          new XdrString('Not enough cowbell!')
        )
      );
      Uint8List data = new Uint8List.view(message.toBuffer());
      expect(data, equals(serialized));
    });

    test('can deserialize from buffer', () {
      BlockMessage message = new BlockMessage.fromBytes(serialized);
      BlockPayload payload = message.payload;
      expect(payload, isNotNull);
      expect(payload, new isInstanceOf<Close>());

      Close close = payload as Close;
      expect(close.reason.value, equals('Not enough cowbell!'));
    });
  });
}
