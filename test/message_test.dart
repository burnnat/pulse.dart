library syncthing.message_test;

import 'dart:typed_data';

import 'package:syncthing/protocol/message.dart';
import 'package:syncthing/protocol/xdr.dart';
import 'package:unittest/unittest.dart';

class TestMessage extends Message {
  final int header;
  final TestPayload payload;

  TestMessage(this.header, this.payload);

  ByteBuffer toBuffer() {
    Uint32List payloadData = new Uint32List.view(payload.toBuffer());
    Uint32List data = new Uint32List(payloadData.length + 2);

    // Write message header
    data[0] = header;
    data[1] = payloadData.lengthInBytes;

    // Append message contents
    data.setRange(2, data.length, payloadData);

    return data.buffer;
  }
}

class TestPayload extends XdrPayload {
  final Uint32List data;

  TestPayload(this.data);

  ByteBuffer toBuffer() => data.buffer;
}

void runTests() {
  group('Base message', () {
    int header = 0x189C0700;

    Uint32List payload = new Uint32List(3);
    payload[0] = 0xFF00FF00;
    payload[1] = 0x01234567;
    payload[2] = 0x994E0126;

    TestMessage m = new TestMessage(header, new TestPayload(payload));
    Uint32List data = new Uint32List.view(m.toBuffer());

    test('has correct size', () {
      expect(data, hasLength(payload.length + 2));
    });

    test('encodes header', () => expect(data[0], equals(header)));
    test('encodes length', () => expect(data[1], equals(payload.lengthInBytes)));

    test('encodes payload', () {
      for (int i = 0; i < payload.length; i++) {
        expect(data[i+2], equals(payload[i]), reason: 'data mismatch at $i');
      }
    });
  });
}