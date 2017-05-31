///
//  Generated code. Do not modify.
///
// @ignoreProblemForFile non_constant_identifier_names
// @ignoreProblemForFile library_prefixes
library protocol_bep_pbjson;

const MessageType$json = const {
  '1': 'MessageType',
  '2': const [
    const {'1': 'CLUSTER_CONFIG', '2': 0},
    const {'1': 'INDEX', '2': 1},
    const {'1': 'INDEX_UPDATE', '2': 2},
    const {'1': 'REQUEST', '2': 3},
    const {'1': 'RESPONSE', '2': 4},
    const {'1': 'DOWNLOAD_PROGRESS', '2': 5},
    const {'1': 'PING', '2': 6},
    const {'1': 'CLOSE', '2': 7},
  ],
};

const MessageCompression$json = const {
  '1': 'MessageCompression',
  '2': const [
    const {'1': 'NONE', '2': 0},
    const {'1': 'LZ4', '2': 1},
  ],
};

const Compression$json = const {
  '1': 'Compression',
  '2': const [
    const {'1': 'METADATA', '2': 0},
    const {'1': 'NEVER', '2': 1},
    const {'1': 'ALWAYS', '2': 2},
  ],
};

const FileInfoType$json = const {
  '1': 'FileInfoType',
  '2': const [
    const {'1': 'FILE', '2': 0},
    const {'1': 'DIRECTORY', '2': 1},
    const {'1': 'SYMLINK_FILE', '2': 2},
    const {'1': 'SYMLINK_DIRECTORY', '2': 3},
    const {'1': 'SYMLINK', '2': 4},
  ],
};

const ErrorCode$json = const {
  '1': 'ErrorCode',
  '2': const [
    const {'1': 'NO_ERROR', '2': 0},
    const {'1': 'GENERIC', '2': 1},
    const {'1': 'NO_SUCH_FILE', '2': 2},
    const {'1': 'INVALID_FILE', '2': 3},
  ],
};

const FileDownloadProgressUpdateType$json = const {
  '1': 'FileDownloadProgressUpdateType',
  '2': const [
    const {'1': 'APPEND', '2': 0},
    const {'1': 'FORGET', '2': 1},
  ],
};

const Hello$json = const {
  '1': 'Hello',
  '2': const [
    const {'1': 'device_name', '3': 1, '4': 1, '5': 9},
    const {'1': 'client_name', '3': 2, '4': 1, '5': 9},
    const {'1': 'client_version', '3': 3, '4': 1, '5': 9},
  ],
};

const Header$json = const {
  '1': 'Header',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.protocol.MessageType'},
    const {'1': 'compression', '3': 2, '4': 1, '5': 14, '6': '.protocol.MessageCompression'},
  ],
};

const ClusterConfig$json = const {
  '1': 'ClusterConfig',
  '2': const [
    const {'1': 'folders', '3': 1, '4': 3, '5': 11, '6': '.protocol.Folder'},
  ],
};

const Folder$json = const {
  '1': 'Folder',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9},
    const {'1': 'label', '3': 2, '4': 1, '5': 9},
    const {'1': 'read_only', '3': 3, '4': 1, '5': 8},
    const {'1': 'ignore_permissions', '3': 4, '4': 1, '5': 8},
    const {'1': 'ignore_delete', '3': 5, '4': 1, '5': 8},
    const {'1': 'disable_temp_indexes', '3': 6, '4': 1, '5': 8},
    const {'1': 'paused', '3': 7, '4': 1, '5': 8},
    const {'1': 'devices', '3': 16, '4': 3, '5': 11, '6': '.protocol.Device'},
  ],
};

const Device$json = const {
  '1': 'Device',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 12},
    const {'1': 'name', '3': 2, '4': 1, '5': 9},
    const {'1': 'addresses', '3': 3, '4': 3, '5': 9},
    const {'1': 'compression', '3': 4, '4': 1, '5': 14, '6': '.protocol.Compression'},
    const {'1': 'cert_name', '3': 5, '4': 1, '5': 9},
    const {'1': 'max_sequence', '3': 6, '4': 1, '5': 3},
    const {'1': 'introducer', '3': 7, '4': 1, '5': 8},
    const {'1': 'index_id', '3': 8, '4': 1, '5': 4},
    const {'1': 'skip_introduction_removals', '3': 9, '4': 1, '5': 8},
  ],
};

const Index$json = const {
  '1': 'Index',
  '2': const [
    const {'1': 'folder', '3': 1, '4': 1, '5': 9},
    const {'1': 'files', '3': 2, '4': 3, '5': 11, '6': '.protocol.FileInfo'},
  ],
};

const IndexUpdate$json = const {
  '1': 'IndexUpdate',
  '2': const [
    const {'1': 'folder', '3': 1, '4': 1, '5': 9},
    const {'1': 'files', '3': 2, '4': 3, '5': 11, '6': '.protocol.FileInfo'},
  ],
};

const FileInfo$json = const {
  '1': 'FileInfo',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9},
    const {'1': 'type', '3': 2, '4': 1, '5': 14, '6': '.protocol.FileInfoType'},
    const {'1': 'size', '3': 3, '4': 1, '5': 3},
    const {'1': 'permissions', '3': 4, '4': 1, '5': 13},
    const {'1': 'modified_s', '3': 5, '4': 1, '5': 3},
    const {'1': 'modified_ns', '3': 11, '4': 1, '5': 5},
    const {'1': 'modified_by', '3': 12, '4': 1, '5': 4},
    const {'1': 'deleted', '3': 6, '4': 1, '5': 8},
    const {'1': 'invalid', '3': 7, '4': 1, '5': 8},
    const {'1': 'no_permissions', '3': 8, '4': 1, '5': 8},
    const {'1': 'version', '3': 9, '4': 1, '5': 11, '6': '.protocol.Vector'},
    const {'1': 'sequence', '3': 10, '4': 1, '5': 3},
    const {'1': 'Blocks', '3': 16, '4': 3, '5': 11, '6': '.protocol.BlockInfo'},
    const {'1': 'symlink_target', '3': 17, '4': 1, '5': 9},
  ],
};

const BlockInfo$json = const {
  '1': 'BlockInfo',
  '2': const [
    const {'1': 'offset', '3': 1, '4': 1, '5': 3},
    const {'1': 'size', '3': 2, '4': 1, '5': 5},
    const {'1': 'hash', '3': 3, '4': 1, '5': 12},
    const {'1': 'weak_hash', '3': 4, '4': 1, '5': 13},
  ],
};

const Vector$json = const {
  '1': 'Vector',
  '2': const [
    const {'1': 'counters', '3': 1, '4': 3, '5': 11, '6': '.protocol.Counter'},
  ],
};

const Counter$json = const {
  '1': 'Counter',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 4},
    const {'1': 'value', '3': 2, '4': 1, '5': 4},
  ],
};

const Request$json = const {
  '1': 'Request',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5},
    const {'1': 'folder', '3': 2, '4': 1, '5': 9},
    const {'1': 'name', '3': 3, '4': 1, '5': 9},
    const {'1': 'offset', '3': 4, '4': 1, '5': 3},
    const {'1': 'size', '3': 5, '4': 1, '5': 5},
    const {'1': 'hash', '3': 6, '4': 1, '5': 12},
    const {'1': 'from_temporary', '3': 7, '4': 1, '5': 8},
  ],
};

const Response$json = const {
  '1': 'Response',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5},
    const {'1': 'data', '3': 2, '4': 1, '5': 12},
    const {'1': 'code', '3': 3, '4': 1, '5': 14, '6': '.protocol.ErrorCode'},
  ],
};

const DownloadProgress$json = const {
  '1': 'DownloadProgress',
  '2': const [
    const {'1': 'folder', '3': 1, '4': 1, '5': 9},
    const {'1': 'updates', '3': 2, '4': 3, '5': 11, '6': '.protocol.FileDownloadProgressUpdate'},
  ],
};

const FileDownloadProgressUpdate$json = const {
  '1': 'FileDownloadProgressUpdate',
  '2': const [
    const {'1': 'update_type', '3': 1, '4': 1, '5': 14, '6': '.protocol.FileDownloadProgressUpdateType'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9},
    const {'1': 'version', '3': 3, '4': 1, '5': 11, '6': '.protocol.Vector'},
    const {
      '1': 'block_indexes',
      '3': 4,
      '4': 3,
      '5': 5,
      '8': const {'2': false},
    },
  ],
};

const Ping$json = const {
  '1': 'Ping',
};

const Close$json = const {
  '1': 'Close',
  '2': const [
    const {'1': 'reason', '3': 1, '4': 1, '5': 9},
  ],
};

