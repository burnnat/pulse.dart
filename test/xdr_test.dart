library syncthing.xdr_test;

import 'dart:typed_data';

import 'package:syncthing/protocol/xdr.dart';
import 'package:unittest/unittest.dart';

void runTests() {
  group('XDR format', () {
    test('encodes Short', () {
      // should be truncated to a 16-bit Short
      Short s = new Short(0xABB86EB3);
      ByteData data = new ByteData.view(s.toBuffer());

      expect(data.lengthInBytes, equals(4));
      expect(data.getUint32(0, Endianness.BIG_ENDIAN), equals(0x6EB30000));
    });

    test('encodes Int', () {
      // should be truncated to a 32-bit Int
      Int i = new Int(0xFBBF803022C4);
      ByteData data = new ByteData.view(i.toBuffer());

      expect(data.lengthInBytes, equals(4));
      expect(data.getUint32(0, Endianness.BIG_ENDIAN), equals(0x803022C4));
    });

    test('encodes Hyper', () {
      // should be truncated to a 64-bit Hyper
      Hyper h = new Hyper(new Int(0xBB7875D264), new Int(0x32FC25F3C0));
      ByteData data = new ByteData.view(h.toBuffer());

      expect(data.lengthInBytes, equals(8));
      expect(data.getUint32(0, Endianness.BIG_ENDIAN), equals(0x7875D264));
      expect(data.getUint32(4, Endianness.BIG_ENDIAN), equals(0xFC25F3C0));
    });

    test('encodes Opaque', () {
      // should be padded to 12 bytes
      Opaque o = new Opaque([
        0x76, 0xDE, 0xC3, 0xD7,
        0x9C, 0x15, 0x22, 0x58,
        0x40, 0xD1
      ]);
      ByteData data = new ByteData.view(o.toBuffer());

      // 12 bytes of data with a 4 byte length header
      expect(data.lengthInBytes, equals(16));
      expect(data.getUint32(0, Endianness.BIG_ENDIAN), equals(10));
      expect(data.getUint32(4, Endianness.BIG_ENDIAN), equals(0x76DEC3D7));
      expect(data.getUint32(8, Endianness.BIG_ENDIAN), equals(0x9C152258));
      expect(data.getUint32(12, Endianness.BIG_ENDIAN), equals(0x40D10000));
    });

    test('encodes String', () {
      // should be padded to 8 bytes
      XdrString s = new XdrString('Me&You!');
      ByteData data = new ByteData.view(s.toBuffer());

      // 8 bytes of data with a 4 byte length header
      expect(data.lengthInBytes, equals(12));
      expect(data.getUint32(0, Endianness.BIG_ENDIAN), equals(7));
      expect(data.getUint32(4, Endianness.BIG_ENDIAN), equals(0x4D652659));
      expect(data.getUint32(8, Endianness.BIG_ENDIAN), equals(0x6F752100));
    });
  });
}