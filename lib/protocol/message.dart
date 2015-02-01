library syncthing.protocol.message;

import 'dart:typed_data';

import 'xdr.dart';

abstract class Message {
  const Message();

  ByteBuffer toBuffer();
  XdrPayload getPayload();
}

abstract class BlockMessage extends Message {
  final int version;
  final int id;
  final int type;
  final bool compressed;

  static const int TYPE_CLUSTER_CONFIG = 0;
  static const int TYPE_INDEX = 1;
  static const int TYPE_REQUEST = 2;
  static const int TYPE_RESPONSE = 3;
  static const int TYPE_PING = 4;
  static const int TYPE_PONG = 5;
  static const int TYPE_INDEX_UPDATE = 6;
  static const int TYPE_CLOSE = 7;

  const BlockMessage(this.version, this.id, this.type, this.compressed);

  @override
  ByteBuffer toBuffer() {
    Uint32List payload = new Uint32List.view(getPayload().toBuffer());
    Uint32List data = new Uint32List(payload.length + 2);

    // Write message header
    data[0] = ((0x000F & version) << 28)
      | ((0x0FFF & id) << 16)
      | ((0x00FF & type) << 8)
      | (compressed ? 1 : 0);
    data[1] = payload.lengthInBytes;

    // Append message contents
    data.setRange(2, data.length, payload);

    return data.buffer;
  }
}