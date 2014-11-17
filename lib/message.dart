library message;

import 'dart:typed_data';

abstract class BlockMessage {
  final int version;
  final int id;
  final int type;
  final bool compressed;

  static final int TYPE_CLUSTER_CONFIG = 0;
  static final int TYPE_INDEX = 1;
  static final int TYPE_REQUEST = 2;
  static final int TYPE_RESPONSE = 3;
  static final int TYPE_PING = 4;
  static final int TYPE_PONG = 5;
  static final int TYPE_INDEX_UPDATE = 6;
  static final int TYPE_CLOSE = 7;

  const BlockMessage(this.version, this.id, this.type, this.compressed);

  ByteBuffer writeData() {
    Uint32List payload = new Uint32List.view(writePayload());
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

  ByteBuffer writePayload();
}