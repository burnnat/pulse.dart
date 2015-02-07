library syncthing.protocol.bep;

import 'dart:typed_data';

import 'package:logging/logging.dart';

import 'message.dart';
import 'xdr.dart';
export 'xdr.dart' show XdrString, Hyper, Int, Opaque;

final Logger logger = new Logger('syncthing.protocol.bep');

/**
 * Returns true if the bit at position [pos] is 1. Otherwise,
 * returns false. For the purposes of this method, the
 * least-significant bit is said to have position 0.
 */
bool _test(int value, int pos) =>
  (value >> pos) & 0x01 == 1;

/**
 * Returns an integer bitmask for the given boolean, with the
 * bit at [pos] set to 1 if [flag] is true, and set to 0 otherwise.
 * For the purposes of this method, the least-significant bit is
 * said to have position 0.
 */
int _set(bool flag, int pos) =>
  (flag ? 1 : 0) << pos;

int _yank(int data, int mask, int shift) {
  int offset = shift * mask.bitLength;
  return (data & (mask << offset)) >> offset;
}

/**
 * Gets the [n]th byte in the integer [data], with n=0 corresponding
 * to the least-significant byte.
 */
int _byte(int data, int n) =>
  _yank(data, 0xFF, n);

/**
 * Gets the [n]th nibble (one nibble is half a byte, or 4 bits) in
 * the integer [data], with n=0 to the least-significant nibble.
 */
int _nibble(int data, int n) =>
  _yank(data, 0xF, n);

class BlockMessage extends Message {
  final int version;
  final int id;
  final bool compressed;

  final BlockPayload payload;

  static const int TYPE_INDEX = 1;
  static const int TYPE_REQUEST = 2;
  static const int TYPE_RESPONSE = 3;
  static const int TYPE_PING = 4;
  static const int TYPE_PONG = 5;
  static const int TYPE_INDEX_UPDATE = 6;
  static const int TYPE_CLOSE = 7;

  const BlockMessage(this.id, this.payload, { this.version: 0, this.compressed: false });

  factory BlockMessage.fromBytes(List<int> bytes) {
    bytes = new List.from(bytes);

    int version = _nibble(bytes[0], 1);

    if (version > 0) {
      throw new UnsupportedVersionError(version);
    }

    int id = (_nibble(bytes[0], 0) << 8) | bytes[1];
    int type = bytes[2];
    bool compressed = _test(bytes[3], 0);

    bytes.removeRange(0, 4);

    Int length = new Int.fromBytes(bytes);
    logger.finest(() => 'Parsing message with length: $length');

    return new BlockMessage(
      id,
      _parsePayload(type, bytes),
      version: version,
      compressed: compressed
    );
  }

  static BlockPayload _parsePayload(int type, List<int> bytes) {
    switch (type) {
      case ClusterConfig.TYPE:
        return new ClusterConfig.fromBytes(bytes);
      case Index.TYPE:
        return new Index.fromBytes(bytes);
      case IndexUpdate.TYPE:
        return new IndexUpdate.fromBytes(bytes);
      default:
        throw new UnknownMessageTypeError(type);
    }
  }

  ByteBuffer toBuffer() {
    if (compressed) {
      throw new UnimplementedError('Message compression is not yet implemented.');
    }

    Uint8List payloadData = new Uint8List.view(payload.toBuffer());
    Uint8List data = new Uint8List(payloadData.length + 8);

    // Write message header
    data[0] = (_nibble(version, 0) << 4) | _nibble(id, 2);
    data[1] = _byte(id, 0);
    data[2] = payload.type;
    data[3] = _set(compressed, 0);

    // Set payload length
    data.setRange(4, 8, new Int(payloadData.lengthInBytes).toBytes());

    // Append message contents
    data.setRange(8, data.length, payloadData);

    return data.buffer;
  }
}

class UnsupportedVersionError extends ProtocolError {
  final int version;

  UnsupportedVersionError(int version)
    : super('Unknown protocol version: $version'),
      this.version = version;
}

class UnknownMessageTypeError extends ProtocolError {
  final int type;

  UnknownMessageTypeError(int type)
    : super('Unknown message type: $type'),
      this.type = type;
}

abstract class BlockPayload extends XdrPayload {
  @transient
  final int type;

  BlockPayload(this.type);
  BlockPayload.fromBytes(this.type, List<int> bytes) : super.fromBytes(bytes);
}

@xdr
class ClusterConfig extends BlockPayload {
  static const int TYPE = 0;

  XdrString clientName;
  XdrString clientVersion;
  List<Folder> folders;
  List<Option> options;

  ClusterConfig(
    this.clientName,
    this.clientVersion,
    this.folders,
    this.options)
      : super(TYPE);

  ClusterConfig.fromBytes(List<int> bytes) : super.fromBytes(TYPE, bytes);
}

@xdr
class Folder extends XdrPayload {
  XdrString id;
  List<Device> devices;

  Folder(this.id, this.devices);
  Folder.fromBytes(List<int> bytes) : super.fromBytes(bytes);
}

@xdr
class Device extends XdrPayload {
  XdrString id;
  DeviceFlags flags;
  Hyper maxLocalVersion;

  Device(this.id, this.flags, this.maxLocalVersion);
  Device.fromBytes(List<int> bytes) : super.fromBytes(bytes);
}

class DeviceFlags extends XdrPayload {
  static const int PRIORITY_HIGH = 0x01;
  static const int PRIORITY_NORMAL = 0x00;
  static const int PRIORITY_LOW = 0x02;
  static const int PRIORITY_DISABLED = 0x03;

  final bool trusted;
  final bool readOnly;
  final bool introducer;
  final int priority;

  const DeviceFlags({
    this.trusted: false,
    this.readOnly: false,
    this.introducer: false,
    this.priority: PRIORITY_NORMAL
  });

  factory DeviceFlags.fromBytes(List<int> bytes) {
    int priority = bytes[1] & 0x03;
    bool introducer = _test(bytes[3], 2);
    bool readOnly = _test(bytes[3], 1);
    bool trusted = _test(bytes[3], 0);

    bytes.removeRange(0, 4);

    return new DeviceFlags(
      trusted: trusted,
      readOnly: readOnly,
      introducer: introducer,
      priority: priority
    );
  }

  @override
  List<int> toBytes() {
    return [
      0x00,
      priority & 0x03,
      0x00,
      _set(introducer, 2) |
        _set(readOnly, 1) |
        _set(trusted, 0)
    ];
  }
}

@xdr
class Option extends XdrPayload {
  XdrString key;
  XdrString value;

  Option(this.key, this.value);
  Option.fromBytes(List<int> bytes) : super.fromBytes(bytes);
}

@xdr
class AbstractIndex extends BlockPayload {
  XdrString folder;
  List<FileInfo> files;

  AbstractIndex(int type, this.folder, this.files) : super(type);
  AbstractIndex.fromBytes(int type, List<int> bytes) : super.fromBytes(type, bytes);
}

@xdr
class Index extends AbstractIndex {
  static const int TYPE = 1;

  Index(XdrString folder, List<FileInfo> files) : super(TYPE, folder, files);
  Index.fromBytes(List<int> bytes) : super.fromBytes(TYPE, bytes);
}

@xdr
class IndexUpdate extends AbstractIndex {
  static const int TYPE = 6;

  IndexUpdate(XdrString folder, List<FileInfo> files) : super(TYPE, folder, files);
  IndexUpdate.fromBytes(List<int> bytes) : super.fromBytes(TYPE, bytes);
}

@xdr
class FileInfo extends XdrPayload {
  XdrString name;
  FileFlags flags;
  Hyper modified;
  Hyper version;
  Hyper localVersion;
  List<BlockInfo> blocks;

  FileInfo(
    this.name,
    this.flags,
    this.modified,
    this.version,
    this.localVersion,
    this.blocks);

  FileInfo.fromBytes(List<int> bytes) : super.fromBytes(bytes);
}

class FileFlags extends XdrPayload {
  final int permissions;
  final bool deleted;
  final bool invalid;
  final bool permissionsMissing;
  final bool symbolicLink;
  final bool undefinedTarget;

  const FileFlags({
    this.permissions: 0x1B6, // Octal 666
    this.deleted: false,
    this.invalid: false,
    this.permissionsMissing: false,
    this.symbolicLink: false,
    this.undefinedTarget: false
  });

  factory FileFlags.fromBytes(List<int> bytes) {
    bool undefinedTarget = _test(bytes[1], 0);
    bool symbolicLink = _test(bytes[2], 7);
    bool permissionsMissing = _test(bytes[2], 6);
    bool invalid = _test(bytes[2], 5);
    bool deleted = _test(bytes[2], 4);
    int permissions = (_nibble(bytes[2], 0) << 8) | bytes[3];

    bytes.removeRange(0, 4);

    return new FileFlags(
        permissions: permissions,
        deleted: deleted,
        invalid: invalid,
        permissionsMissing: permissionsMissing,
        symbolicLink: symbolicLink,
        undefinedTarget: undefinedTarget
    );
  }

  @override
  List<int> toBytes() {
    return [
      0x00,
      _set(undefinedTarget, 0),
      _set(symbolicLink, 7) |
        _set(permissionsMissing, 6) |
        _set(invalid, 5) |
        _set(deleted, 4) |
        _nibble(permissions, 2),
      _byte(permissions, 0)
    ];
  }
}

@xdr
class BlockInfo extends XdrPayload {
  Int size;
  Opaque hash;

  BlockInfo(this.size, this.hash);
  BlockInfo.fromBytes(List<int> bytes) : super.fromBytes(bytes);
}
