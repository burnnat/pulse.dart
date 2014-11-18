import 'dart:typed_data';
import 'package:pulsefs/message.dart';
import 'package:pulsefs/xdr.dart';
import 'package:unittest/unittest.dart';

class TestMessage extends BlockMessage {
  final TestPayload payload;

  TestMessage(int version, int id, int type, this.payload, bool compress)
    : super(version, id, type, compress);

  XdrPayload getPayload() => payload;
}

class TestPayload extends XdrPayload {
  final Uint32List data;

  TestPayload(this.data);

  ByteBuffer toBuffer() => data.buffer;
}

void runTests() {
  group('Base message', () {
    Uint32List payload = new Uint32List(3);
    payload[0] = 0xFF00FF00;
    payload[1] = 0x01234567;
    payload[2] = 0x994E0126;

    TestMessage m = new TestMessage(
      1,
      2204,
      BlockMessage.TYPE_CLOSE,
      new TestPayload(payload),
      false
    );

    Uint32List data = new Uint32List.view(m.toBuffer());

    test('has correct size', () {
      expect(data, hasLength(payload.length + 2));
    });

    test('encodes header', () => expect(data[0], equals(0x189C0700)));
    test('encodes length', () => expect(data[1], equals(payload.lengthInBytes)));

    test('encodes payload', () {
      for (int i = 0; i < payload.length; i++) {
        expect(data[i+2], equals(payload[i]), reason: 'data mismatch at $i');
      }
    });
  });
}