library syncthing.protocol.message;

import 'dart:typed_data';

import 'xdr.dart';

abstract class Message {
  const Message();

  XdrPayload get payload;
  ByteBuffer toBuffer();
}

class ProtocolError extends Error {
  final String message;
  ProtocolError(this.message);
  String toString() => "Protocol error: $message";
}
