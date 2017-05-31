///
//  Generated code. Do not modify.
///
// @ignoreProblemForFile non_constant_identifier_names
// @ignoreProblemForFile library_prefixes
library protocol_bep_pbenum;

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart';

class MessageType extends ProtobufEnum {
  static const MessageType CLUSTER_CONFIG = const MessageType._(0, 'CLUSTER_CONFIG');
  static const MessageType INDEX = const MessageType._(1, 'INDEX');
  static const MessageType INDEX_UPDATE = const MessageType._(2, 'INDEX_UPDATE');
  static const MessageType REQUEST = const MessageType._(3, 'REQUEST');
  static const MessageType RESPONSE = const MessageType._(4, 'RESPONSE');
  static const MessageType DOWNLOAD_PROGRESS = const MessageType._(5, 'DOWNLOAD_PROGRESS');
  static const MessageType PING = const MessageType._(6, 'PING');
  static const MessageType CLOSE = const MessageType._(7, 'CLOSE');

  static const List<MessageType> values = const <MessageType> [
    CLUSTER_CONFIG,
    INDEX,
    INDEX_UPDATE,
    REQUEST,
    RESPONSE,
    DOWNLOAD_PROGRESS,
    PING,
    CLOSE,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static MessageType valueOf(int value) => _byValue[value] as MessageType;
  static void $checkItem(MessageType v) {
    if (v is !MessageType) checkItemFailed(v, 'MessageType');
  }

  const MessageType._(int v, String n) : super(v, n);
}

class MessageCompression extends ProtobufEnum {
  static const MessageCompression NONE = const MessageCompression._(0, 'NONE');
  static const MessageCompression LZ4 = const MessageCompression._(1, 'LZ4');

  static const List<MessageCompression> values = const <MessageCompression> [
    NONE,
    LZ4,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static MessageCompression valueOf(int value) => _byValue[value] as MessageCompression;
  static void $checkItem(MessageCompression v) {
    if (v is !MessageCompression) checkItemFailed(v, 'MessageCompression');
  }

  const MessageCompression._(int v, String n) : super(v, n);
}

class Compression extends ProtobufEnum {
  static const Compression METADATA = const Compression._(0, 'METADATA');
  static const Compression NEVER = const Compression._(1, 'NEVER');
  static const Compression ALWAYS = const Compression._(2, 'ALWAYS');

  static const List<Compression> values = const <Compression> [
    METADATA,
    NEVER,
    ALWAYS,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static Compression valueOf(int value) => _byValue[value] as Compression;
  static void $checkItem(Compression v) {
    if (v is !Compression) checkItemFailed(v, 'Compression');
  }

  const Compression._(int v, String n) : super(v, n);
}

class FileInfoType extends ProtobufEnum {
  static const FileInfoType FILE = const FileInfoType._(0, 'FILE');
  static const FileInfoType DIRECTORY = const FileInfoType._(1, 'DIRECTORY');
  static const FileInfoType SYMLINK_FILE = const FileInfoType._(2, 'SYMLINK_FILE');
  static const FileInfoType SYMLINK_DIRECTORY = const FileInfoType._(3, 'SYMLINK_DIRECTORY');
  static const FileInfoType SYMLINK = const FileInfoType._(4, 'SYMLINK');

  static const List<FileInfoType> values = const <FileInfoType> [
    FILE,
    DIRECTORY,
    SYMLINK_FILE,
    SYMLINK_DIRECTORY,
    SYMLINK,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static FileInfoType valueOf(int value) => _byValue[value] as FileInfoType;
  static void $checkItem(FileInfoType v) {
    if (v is !FileInfoType) checkItemFailed(v, 'FileInfoType');
  }

  const FileInfoType._(int v, String n) : super(v, n);
}

class ErrorCode extends ProtobufEnum {
  static const ErrorCode NO_ERROR = const ErrorCode._(0, 'NO_ERROR');
  static const ErrorCode GENERIC = const ErrorCode._(1, 'GENERIC');
  static const ErrorCode NO_SUCH_FILE = const ErrorCode._(2, 'NO_SUCH_FILE');
  static const ErrorCode INVALID_FILE = const ErrorCode._(3, 'INVALID_FILE');

  static const List<ErrorCode> values = const <ErrorCode> [
    NO_ERROR,
    GENERIC,
    NO_SUCH_FILE,
    INVALID_FILE,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static ErrorCode valueOf(int value) => _byValue[value] as ErrorCode;
  static void $checkItem(ErrorCode v) {
    if (v is !ErrorCode) checkItemFailed(v, 'ErrorCode');
  }

  const ErrorCode._(int v, String n) : super(v, n);
}

class FileDownloadProgressUpdateType extends ProtobufEnum {
  static const FileDownloadProgressUpdateType APPEND = const FileDownloadProgressUpdateType._(0, 'APPEND');
  static const FileDownloadProgressUpdateType FORGET = const FileDownloadProgressUpdateType._(1, 'FORGET');

  static const List<FileDownloadProgressUpdateType> values = const <FileDownloadProgressUpdateType> [
    APPEND,
    FORGET,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static FileDownloadProgressUpdateType valueOf(int value) => _byValue[value] as FileDownloadProgressUpdateType;
  static void $checkItem(FileDownloadProgressUpdateType v) {
    if (v is !FileDownloadProgressUpdateType) checkItemFailed(v, 'FileDownloadProgressUpdateType');
  }

  const FileDownloadProgressUpdateType._(int v, String n) : super(v, n);
}

