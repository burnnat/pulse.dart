///
//  Generated code. Do not modify.
///
// @ignoreProblemForFile non_constant_identifier_names
// @ignoreProblemForFile library_prefixes
library protocol_bep;

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;
import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

import 'bep.pbenum.dart';

export 'bep.pbenum.dart';

class Hello extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Hello')
    ..a/*<String>*/(1, 'deviceName', PbFieldType.OS)
    ..a/*<String>*/(2, 'clientName', PbFieldType.OS)
    ..a/*<String>*/(3, 'clientVersion', PbFieldType.OS)
    ..hasRequiredFields = false
  ;

  Hello() : super();
  Hello.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Hello.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Hello clone() => new Hello()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Hello create() => new Hello();
  static PbList<Hello> createRepeated() => new PbList<Hello>();
  static Hello getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyHello();
    return _defaultInstance;
  }
  static Hello _defaultInstance;
  static void $checkItem(Hello v) {
    if (v is !Hello) checkItemFailed(v, 'Hello');
  }

  String get deviceName => $_get(0, 1, '');
  set deviceName(String v) { $_setString(0, 1, v); }
  bool hasDeviceName() => $_has(0, 1);
  void clearDeviceName() => clearField(1);

  String get clientName => $_get(1, 2, '');
  set clientName(String v) { $_setString(1, 2, v); }
  bool hasClientName() => $_has(1, 2);
  void clearClientName() => clearField(2);

  String get clientVersion => $_get(2, 3, '');
  set clientVersion(String v) { $_setString(2, 3, v); }
  bool hasClientVersion() => $_has(2, 3);
  void clearClientVersion() => clearField(3);
}

class _ReadonlyHello extends Hello with ReadonlyMessageMixin {}

class Header extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Header')
    ..e/*<MessageType>*/(1, 'type', PbFieldType.OE, MessageType.CLUSTER_CONFIG, MessageType.valueOf)
    ..e/*<MessageCompression>*/(2, 'compression', PbFieldType.OE, MessageCompression.NONE, MessageCompression.valueOf)
    ..hasRequiredFields = false
  ;

  Header() : super();
  Header.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Header.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Header clone() => new Header()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Header create() => new Header();
  static PbList<Header> createRepeated() => new PbList<Header>();
  static Header getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyHeader();
    return _defaultInstance;
  }
  static Header _defaultInstance;
  static void $checkItem(Header v) {
    if (v is !Header) checkItemFailed(v, 'Header');
  }

  MessageType get type => $_get(0, 1, null);
  set type(MessageType v) { setField(1, v); }
  bool hasType() => $_has(0, 1);
  void clearType() => clearField(1);

  MessageCompression get compression => $_get(1, 2, null);
  set compression(MessageCompression v) { setField(2, v); }
  bool hasCompression() => $_has(1, 2);
  void clearCompression() => clearField(2);
}

class _ReadonlyHeader extends Header with ReadonlyMessageMixin {}

class ClusterConfig extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ClusterConfig')
    ..pp/*<Folder>*/(1, 'folders', PbFieldType.PM, Folder.$checkItem, Folder.create)
    ..hasRequiredFields = false
  ;

  ClusterConfig() : super();
  ClusterConfig.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ClusterConfig.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ClusterConfig clone() => new ClusterConfig()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ClusterConfig create() => new ClusterConfig();
  static PbList<ClusterConfig> createRepeated() => new PbList<ClusterConfig>();
  static ClusterConfig getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyClusterConfig();
    return _defaultInstance;
  }
  static ClusterConfig _defaultInstance;
  static void $checkItem(ClusterConfig v) {
    if (v is !ClusterConfig) checkItemFailed(v, 'ClusterConfig');
  }

  List<Folder> get folders => $_get(0, 1, null);
}

class _ReadonlyClusterConfig extends ClusterConfig with ReadonlyMessageMixin {}

class Folder extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Folder')
    ..a/*<String>*/(1, 'id', PbFieldType.OS)
    ..a/*<String>*/(2, 'label', PbFieldType.OS)
    ..a/*<bool>*/(3, 'readOnly', PbFieldType.OB)
    ..a/*<bool>*/(4, 'ignorePermissions', PbFieldType.OB)
    ..a/*<bool>*/(5, 'ignoreDelete', PbFieldType.OB)
    ..a/*<bool>*/(6, 'disableTempIndexes', PbFieldType.OB)
    ..a/*<bool>*/(7, 'paused', PbFieldType.OB)
    ..pp/*<Device>*/(16, 'devices', PbFieldType.PM, Device.$checkItem, Device.create)
    ..hasRequiredFields = false
  ;

  Folder() : super();
  Folder.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Folder.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Folder clone() => new Folder()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Folder create() => new Folder();
  static PbList<Folder> createRepeated() => new PbList<Folder>();
  static Folder getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyFolder();
    return _defaultInstance;
  }
  static Folder _defaultInstance;
  static void $checkItem(Folder v) {
    if (v is !Folder) checkItemFailed(v, 'Folder');
  }

  String get id => $_get(0, 1, '');
  set id(String v) { $_setString(0, 1, v); }
  bool hasId() => $_has(0, 1);
  void clearId() => clearField(1);

  String get label => $_get(1, 2, '');
  set label(String v) { $_setString(1, 2, v); }
  bool hasLabel() => $_has(1, 2);
  void clearLabel() => clearField(2);

  bool get readOnly => $_get(2, 3, false);
  set readOnly(bool v) { $_setBool(2, 3, v); }
  bool hasReadOnly() => $_has(2, 3);
  void clearReadOnly() => clearField(3);

  bool get ignorePermissions => $_get(3, 4, false);
  set ignorePermissions(bool v) { $_setBool(3, 4, v); }
  bool hasIgnorePermissions() => $_has(3, 4);
  void clearIgnorePermissions() => clearField(4);

  bool get ignoreDelete => $_get(4, 5, false);
  set ignoreDelete(bool v) { $_setBool(4, 5, v); }
  bool hasIgnoreDelete() => $_has(4, 5);
  void clearIgnoreDelete() => clearField(5);

  bool get disableTempIndexes => $_get(5, 6, false);
  set disableTempIndexes(bool v) { $_setBool(5, 6, v); }
  bool hasDisableTempIndexes() => $_has(5, 6);
  void clearDisableTempIndexes() => clearField(6);

  bool get paused => $_get(6, 7, false);
  set paused(bool v) { $_setBool(6, 7, v); }
  bool hasPaused() => $_has(6, 7);
  void clearPaused() => clearField(7);

  List<Device> get devices => $_get(7, 16, null);
}

class _ReadonlyFolder extends Folder with ReadonlyMessageMixin {}

class Device extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Device')
    ..a/*<List<int>>*/(1, 'id', PbFieldType.OY)
    ..a/*<String>*/(2, 'name', PbFieldType.OS)
    ..p/*<String>*/(3, 'addresses', PbFieldType.PS)
    ..e/*<Compression>*/(4, 'compression', PbFieldType.OE, Compression.METADATA, Compression.valueOf)
    ..a/*<String>*/(5, 'certName', PbFieldType.OS)
    ..a/*<Int64>*/(6, 'maxSequence', PbFieldType.O6, Int64.ZERO)
    ..a/*<bool>*/(7, 'introducer', PbFieldType.OB)
    ..a/*<Int64>*/(8, 'indexId', PbFieldType.OU6, Int64.ZERO)
    ..a/*<bool>*/(9, 'skipIntroductionRemovals', PbFieldType.OB)
    ..hasRequiredFields = false
  ;

  Device() : super();
  Device.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Device.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Device clone() => new Device()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Device create() => new Device();
  static PbList<Device> createRepeated() => new PbList<Device>();
  static Device getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDevice();
    return _defaultInstance;
  }
  static Device _defaultInstance;
  static void $checkItem(Device v) {
    if (v is !Device) checkItemFailed(v, 'Device');
  }

  List<int> get id => $_get(0, 1, null);
  set id(List<int> v) { $_setBytes(0, 1, v); }
  bool hasId() => $_has(0, 1);
  void clearId() => clearField(1);

  String get name => $_get(1, 2, '');
  set name(String v) { $_setString(1, 2, v); }
  bool hasName() => $_has(1, 2);
  void clearName() => clearField(2);

  List<String> get addresses => $_get(2, 3, null);

  Compression get compression => $_get(3, 4, null);
  set compression(Compression v) { setField(4, v); }
  bool hasCompression() => $_has(3, 4);
  void clearCompression() => clearField(4);

  String get certName => $_get(4, 5, '');
  set certName(String v) { $_setString(4, 5, v); }
  bool hasCertName() => $_has(4, 5);
  void clearCertName() => clearField(5);

  Int64 get maxSequence => $_get(5, 6, null);
  set maxSequence(Int64 v) { $_setInt64(5, 6, v); }
  bool hasMaxSequence() => $_has(5, 6);
  void clearMaxSequence() => clearField(6);

  bool get introducer => $_get(6, 7, false);
  set introducer(bool v) { $_setBool(6, 7, v); }
  bool hasIntroducer() => $_has(6, 7);
  void clearIntroducer() => clearField(7);

  Int64 get indexId => $_get(7, 8, null);
  set indexId(Int64 v) { $_setInt64(7, 8, v); }
  bool hasIndexId() => $_has(7, 8);
  void clearIndexId() => clearField(8);

  bool get skipIntroductionRemovals => $_get(8, 9, false);
  set skipIntroductionRemovals(bool v) { $_setBool(8, 9, v); }
  bool hasSkipIntroductionRemovals() => $_has(8, 9);
  void clearSkipIntroductionRemovals() => clearField(9);
}

class _ReadonlyDevice extends Device with ReadonlyMessageMixin {}

class Index extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Index')
    ..a/*<String>*/(1, 'folder', PbFieldType.OS)
    ..pp/*<FileInfo>*/(2, 'files', PbFieldType.PM, FileInfo.$checkItem, FileInfo.create)
    ..hasRequiredFields = false
  ;

  Index() : super();
  Index.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Index.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Index clone() => new Index()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Index create() => new Index();
  static PbList<Index> createRepeated() => new PbList<Index>();
  static Index getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyIndex();
    return _defaultInstance;
  }
  static Index _defaultInstance;
  static void $checkItem(Index v) {
    if (v is !Index) checkItemFailed(v, 'Index');
  }

  String get folder => $_get(0, 1, '');
  set folder(String v) { $_setString(0, 1, v); }
  bool hasFolder() => $_has(0, 1);
  void clearFolder() => clearField(1);

  List<FileInfo> get files => $_get(1, 2, null);
}

class _ReadonlyIndex extends Index with ReadonlyMessageMixin {}

class IndexUpdate extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('IndexUpdate')
    ..a/*<String>*/(1, 'folder', PbFieldType.OS)
    ..pp/*<FileInfo>*/(2, 'files', PbFieldType.PM, FileInfo.$checkItem, FileInfo.create)
    ..hasRequiredFields = false
  ;

  IndexUpdate() : super();
  IndexUpdate.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  IndexUpdate.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  IndexUpdate clone() => new IndexUpdate()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static IndexUpdate create() => new IndexUpdate();
  static PbList<IndexUpdate> createRepeated() => new PbList<IndexUpdate>();
  static IndexUpdate getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyIndexUpdate();
    return _defaultInstance;
  }
  static IndexUpdate _defaultInstance;
  static void $checkItem(IndexUpdate v) {
    if (v is !IndexUpdate) checkItemFailed(v, 'IndexUpdate');
  }

  String get folder => $_get(0, 1, '');
  set folder(String v) { $_setString(0, 1, v); }
  bool hasFolder() => $_has(0, 1);
  void clearFolder() => clearField(1);

  List<FileInfo> get files => $_get(1, 2, null);
}

class _ReadonlyIndexUpdate extends IndexUpdate with ReadonlyMessageMixin {}

class FileInfo extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FileInfo')
    ..a/*<String>*/(1, 'name', PbFieldType.OS)
    ..e/*<FileInfoType>*/(2, 'type', PbFieldType.OE, FileInfoType.FILE, FileInfoType.valueOf)
    ..a/*<Int64>*/(3, 'size', PbFieldType.O6, Int64.ZERO)
    ..a/*<int>*/(4, 'permissions', PbFieldType.OU3)
    ..a/*<Int64>*/(5, 'modifiedS', PbFieldType.O6, Int64.ZERO)
    ..a/*<bool>*/(6, 'deleted', PbFieldType.OB)
    ..a/*<bool>*/(7, 'invalid', PbFieldType.OB)
    ..a/*<bool>*/(8, 'noPermissions', PbFieldType.OB)
    ..a/*<Vector>*/(9, 'version', PbFieldType.OM, Vector.getDefault, Vector.create)
    ..a/*<Int64>*/(10, 'sequence', PbFieldType.O6, Int64.ZERO)
    ..a/*<int>*/(11, 'modifiedNs', PbFieldType.O3)
    ..a/*<Int64>*/(12, 'modifiedBy', PbFieldType.OU6, Int64.ZERO)
    ..pp/*<BlockInfo>*/(16, 'blocks', PbFieldType.PM, BlockInfo.$checkItem, BlockInfo.create)
    ..a/*<String>*/(17, 'symlinkTarget', PbFieldType.OS)
    ..hasRequiredFields = false
  ;

  FileInfo() : super();
  FileInfo.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FileInfo.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FileInfo clone() => new FileInfo()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static FileInfo create() => new FileInfo();
  static PbList<FileInfo> createRepeated() => new PbList<FileInfo>();
  static FileInfo getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyFileInfo();
    return _defaultInstance;
  }
  static FileInfo _defaultInstance;
  static void $checkItem(FileInfo v) {
    if (v is !FileInfo) checkItemFailed(v, 'FileInfo');
  }

  String get name => $_get(0, 1, '');
  set name(String v) { $_setString(0, 1, v); }
  bool hasName() => $_has(0, 1);
  void clearName() => clearField(1);

  FileInfoType get type => $_get(1, 2, null);
  set type(FileInfoType v) { setField(2, v); }
  bool hasType() => $_has(1, 2);
  void clearType() => clearField(2);

  Int64 get size => $_get(2, 3, null);
  set size(Int64 v) { $_setInt64(2, 3, v); }
  bool hasSize() => $_has(2, 3);
  void clearSize() => clearField(3);

  int get permissions => $_get(3, 4, 0);
  set permissions(int v) { $_setUnsignedInt32(3, 4, v); }
  bool hasPermissions() => $_has(3, 4);
  void clearPermissions() => clearField(4);

  Int64 get modifiedS => $_get(4, 5, null);
  set modifiedS(Int64 v) { $_setInt64(4, 5, v); }
  bool hasModifiedS() => $_has(4, 5);
  void clearModifiedS() => clearField(5);

  bool get deleted => $_get(5, 6, false);
  set deleted(bool v) { $_setBool(5, 6, v); }
  bool hasDeleted() => $_has(5, 6);
  void clearDeleted() => clearField(6);

  bool get invalid => $_get(6, 7, false);
  set invalid(bool v) { $_setBool(6, 7, v); }
  bool hasInvalid() => $_has(6, 7);
  void clearInvalid() => clearField(7);

  bool get noPermissions => $_get(7, 8, false);
  set noPermissions(bool v) { $_setBool(7, 8, v); }
  bool hasNoPermissions() => $_has(7, 8);
  void clearNoPermissions() => clearField(8);

  Vector get version => $_get(8, 9, null);
  set version(Vector v) { setField(9, v); }
  bool hasVersion() => $_has(8, 9);
  void clearVersion() => clearField(9);

  Int64 get sequence => $_get(9, 10, null);
  set sequence(Int64 v) { $_setInt64(9, 10, v); }
  bool hasSequence() => $_has(9, 10);
  void clearSequence() => clearField(10);

  int get modifiedNs => $_get(10, 11, 0);
  set modifiedNs(int v) { $_setUnsignedInt32(10, 11, v); }
  bool hasModifiedNs() => $_has(10, 11);
  void clearModifiedNs() => clearField(11);

  Int64 get modifiedBy => $_get(11, 12, null);
  set modifiedBy(Int64 v) { $_setInt64(11, 12, v); }
  bool hasModifiedBy() => $_has(11, 12);
  void clearModifiedBy() => clearField(12);

  List<BlockInfo> get blocks => $_get(12, 16, null);

  String get symlinkTarget => $_get(13, 17, '');
  set symlinkTarget(String v) { $_setString(13, 17, v); }
  bool hasSymlinkTarget() => $_has(13, 17);
  void clearSymlinkTarget() => clearField(17);
}

class _ReadonlyFileInfo extends FileInfo with ReadonlyMessageMixin {}

class BlockInfo extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('BlockInfo')
    ..a/*<Int64>*/(1, 'offset', PbFieldType.O6, Int64.ZERO)
    ..a/*<int>*/(2, 'size', PbFieldType.O3)
    ..a/*<List<int>>*/(3, 'hash', PbFieldType.OY)
    ..a/*<int>*/(4, 'weakHash', PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  BlockInfo() : super();
  BlockInfo.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  BlockInfo.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  BlockInfo clone() => new BlockInfo()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static BlockInfo create() => new BlockInfo();
  static PbList<BlockInfo> createRepeated() => new PbList<BlockInfo>();
  static BlockInfo getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyBlockInfo();
    return _defaultInstance;
  }
  static BlockInfo _defaultInstance;
  static void $checkItem(BlockInfo v) {
    if (v is !BlockInfo) checkItemFailed(v, 'BlockInfo');
  }

  Int64 get offset => $_get(0, 1, null);
  set offset(Int64 v) { $_setInt64(0, 1, v); }
  bool hasOffset() => $_has(0, 1);
  void clearOffset() => clearField(1);

  int get size => $_get(1, 2, 0);
  set size(int v) { $_setUnsignedInt32(1, 2, v); }
  bool hasSize() => $_has(1, 2);
  void clearSize() => clearField(2);

  List<int> get hash => $_get(2, 3, null);
  set hash(List<int> v) { $_setBytes(2, 3, v); }
  bool hasHash() => $_has(2, 3);
  void clearHash() => clearField(3);

  int get weakHash => $_get(3, 4, 0);
  set weakHash(int v) { $_setUnsignedInt32(3, 4, v); }
  bool hasWeakHash() => $_has(3, 4);
  void clearWeakHash() => clearField(4);
}

class _ReadonlyBlockInfo extends BlockInfo with ReadonlyMessageMixin {}

class Vector extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Vector')
    ..pp/*<Counter>*/(1, 'counters', PbFieldType.PM, Counter.$checkItem, Counter.create)
    ..hasRequiredFields = false
  ;

  Vector() : super();
  Vector.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Vector.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Vector clone() => new Vector()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Vector create() => new Vector();
  static PbList<Vector> createRepeated() => new PbList<Vector>();
  static Vector getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyVector();
    return _defaultInstance;
  }
  static Vector _defaultInstance;
  static void $checkItem(Vector v) {
    if (v is !Vector) checkItemFailed(v, 'Vector');
  }

  List<Counter> get counters => $_get(0, 1, null);
}

class _ReadonlyVector extends Vector with ReadonlyMessageMixin {}

class Counter extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Counter')
    ..a/*<Int64>*/(1, 'id', PbFieldType.OU6, Int64.ZERO)
    ..a/*<Int64>*/(2, 'value', PbFieldType.OU6, Int64.ZERO)
    ..hasRequiredFields = false
  ;

  Counter() : super();
  Counter.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Counter.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Counter clone() => new Counter()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Counter create() => new Counter();
  static PbList<Counter> createRepeated() => new PbList<Counter>();
  static Counter getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyCounter();
    return _defaultInstance;
  }
  static Counter _defaultInstance;
  static void $checkItem(Counter v) {
    if (v is !Counter) checkItemFailed(v, 'Counter');
  }

  Int64 get id => $_get(0, 1, null);
  set id(Int64 v) { $_setInt64(0, 1, v); }
  bool hasId() => $_has(0, 1);
  void clearId() => clearField(1);

  Int64 get value => $_get(1, 2, null);
  set value(Int64 v) { $_setInt64(1, 2, v); }
  bool hasValue() => $_has(1, 2);
  void clearValue() => clearField(2);
}

class _ReadonlyCounter extends Counter with ReadonlyMessageMixin {}

class Request extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Request')
    ..a/*<int>*/(1, 'id', PbFieldType.O3)
    ..a/*<String>*/(2, 'folder', PbFieldType.OS)
    ..a/*<String>*/(3, 'name', PbFieldType.OS)
    ..a/*<Int64>*/(4, 'offset', PbFieldType.O6, Int64.ZERO)
    ..a/*<int>*/(5, 'size', PbFieldType.O3)
    ..a/*<List<int>>*/(6, 'hash', PbFieldType.OY)
    ..a/*<bool>*/(7, 'fromTemporary', PbFieldType.OB)
    ..hasRequiredFields = false
  ;

  Request() : super();
  Request.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Request.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Request clone() => new Request()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Request create() => new Request();
  static PbList<Request> createRepeated() => new PbList<Request>();
  static Request getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyRequest();
    return _defaultInstance;
  }
  static Request _defaultInstance;
  static void $checkItem(Request v) {
    if (v is !Request) checkItemFailed(v, 'Request');
  }

  int get id => $_get(0, 1, 0);
  set id(int v) { $_setUnsignedInt32(0, 1, v); }
  bool hasId() => $_has(0, 1);
  void clearId() => clearField(1);

  String get folder => $_get(1, 2, '');
  set folder(String v) { $_setString(1, 2, v); }
  bool hasFolder() => $_has(1, 2);
  void clearFolder() => clearField(2);

  String get name => $_get(2, 3, '');
  set name(String v) { $_setString(2, 3, v); }
  bool hasName() => $_has(2, 3);
  void clearName() => clearField(3);

  Int64 get offset => $_get(3, 4, null);
  set offset(Int64 v) { $_setInt64(3, 4, v); }
  bool hasOffset() => $_has(3, 4);
  void clearOffset() => clearField(4);

  int get size => $_get(4, 5, 0);
  set size(int v) { $_setUnsignedInt32(4, 5, v); }
  bool hasSize() => $_has(4, 5);
  void clearSize() => clearField(5);

  List<int> get hash => $_get(5, 6, null);
  set hash(List<int> v) { $_setBytes(5, 6, v); }
  bool hasHash() => $_has(5, 6);
  void clearHash() => clearField(6);

  bool get fromTemporary => $_get(6, 7, false);
  set fromTemporary(bool v) { $_setBool(6, 7, v); }
  bool hasFromTemporary() => $_has(6, 7);
  void clearFromTemporary() => clearField(7);
}

class _ReadonlyRequest extends Request with ReadonlyMessageMixin {}

class Response extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Response')
    ..a/*<int>*/(1, 'id', PbFieldType.O3)
    ..a/*<List<int>>*/(2, 'data', PbFieldType.OY)
    ..e/*<ErrorCode>*/(3, 'code', PbFieldType.OE, ErrorCode.NO_ERROR, ErrorCode.valueOf)
    ..hasRequiredFields = false
  ;

  Response() : super();
  Response.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Response.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Response clone() => new Response()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Response create() => new Response();
  static PbList<Response> createRepeated() => new PbList<Response>();
  static Response getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyResponse();
    return _defaultInstance;
  }
  static Response _defaultInstance;
  static void $checkItem(Response v) {
    if (v is !Response) checkItemFailed(v, 'Response');
  }

  int get id => $_get(0, 1, 0);
  set id(int v) { $_setUnsignedInt32(0, 1, v); }
  bool hasId() => $_has(0, 1);
  void clearId() => clearField(1);

  List<int> get data => $_get(1, 2, null);
  set data(List<int> v) { $_setBytes(1, 2, v); }
  bool hasData() => $_has(1, 2);
  void clearData() => clearField(2);

  ErrorCode get code => $_get(2, 3, null);
  set code(ErrorCode v) { setField(3, v); }
  bool hasCode() => $_has(2, 3);
  void clearCode() => clearField(3);
}

class _ReadonlyResponse extends Response with ReadonlyMessageMixin {}

class DownloadProgress extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DownloadProgress')
    ..a/*<String>*/(1, 'folder', PbFieldType.OS)
    ..pp/*<FileDownloadProgressUpdate>*/(2, 'updates', PbFieldType.PM, FileDownloadProgressUpdate.$checkItem, FileDownloadProgressUpdate.create)
    ..hasRequiredFields = false
  ;

  DownloadProgress() : super();
  DownloadProgress.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DownloadProgress.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DownloadProgress clone() => new DownloadProgress()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DownloadProgress create() => new DownloadProgress();
  static PbList<DownloadProgress> createRepeated() => new PbList<DownloadProgress>();
  static DownloadProgress getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDownloadProgress();
    return _defaultInstance;
  }
  static DownloadProgress _defaultInstance;
  static void $checkItem(DownloadProgress v) {
    if (v is !DownloadProgress) checkItemFailed(v, 'DownloadProgress');
  }

  String get folder => $_get(0, 1, '');
  set folder(String v) { $_setString(0, 1, v); }
  bool hasFolder() => $_has(0, 1);
  void clearFolder() => clearField(1);

  List<FileDownloadProgressUpdate> get updates => $_get(1, 2, null);
}

class _ReadonlyDownloadProgress extends DownloadProgress with ReadonlyMessageMixin {}

class FileDownloadProgressUpdate extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FileDownloadProgressUpdate')
    ..e/*<FileDownloadProgressUpdateType>*/(1, 'updateType', PbFieldType.OE, FileDownloadProgressUpdateType.APPEND, FileDownloadProgressUpdateType.valueOf)
    ..a/*<String>*/(2, 'name', PbFieldType.OS)
    ..a/*<Vector>*/(3, 'version', PbFieldType.OM, Vector.getDefault, Vector.create)
    ..p/*<int>*/(4, 'blockIndexes', PbFieldType.P3)
    ..hasRequiredFields = false
  ;

  FileDownloadProgressUpdate() : super();
  FileDownloadProgressUpdate.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FileDownloadProgressUpdate.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FileDownloadProgressUpdate clone() => new FileDownloadProgressUpdate()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static FileDownloadProgressUpdate create() => new FileDownloadProgressUpdate();
  static PbList<FileDownloadProgressUpdate> createRepeated() => new PbList<FileDownloadProgressUpdate>();
  static FileDownloadProgressUpdate getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyFileDownloadProgressUpdate();
    return _defaultInstance;
  }
  static FileDownloadProgressUpdate _defaultInstance;
  static void $checkItem(FileDownloadProgressUpdate v) {
    if (v is !FileDownloadProgressUpdate) checkItemFailed(v, 'FileDownloadProgressUpdate');
  }

  FileDownloadProgressUpdateType get updateType => $_get(0, 1, null);
  set updateType(FileDownloadProgressUpdateType v) { setField(1, v); }
  bool hasUpdateType() => $_has(0, 1);
  void clearUpdateType() => clearField(1);

  String get name => $_get(1, 2, '');
  set name(String v) { $_setString(1, 2, v); }
  bool hasName() => $_has(1, 2);
  void clearName() => clearField(2);

  Vector get version => $_get(2, 3, null);
  set version(Vector v) { setField(3, v); }
  bool hasVersion() => $_has(2, 3);
  void clearVersion() => clearField(3);

  List<int> get blockIndexes => $_get(3, 4, null);
}

class _ReadonlyFileDownloadProgressUpdate extends FileDownloadProgressUpdate with ReadonlyMessageMixin {}

class Ping extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Ping')
    ..hasRequiredFields = false
  ;

  Ping() : super();
  Ping.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Ping.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Ping clone() => new Ping()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Ping create() => new Ping();
  static PbList<Ping> createRepeated() => new PbList<Ping>();
  static Ping getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyPing();
    return _defaultInstance;
  }
  static Ping _defaultInstance;
  static void $checkItem(Ping v) {
    if (v is !Ping) checkItemFailed(v, 'Ping');
  }
}

class _ReadonlyPing extends Ping with ReadonlyMessageMixin {}

class Close extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Close')
    ..a/*<String>*/(1, 'reason', PbFieldType.OS)
    ..hasRequiredFields = false
  ;

  Close() : super();
  Close.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Close.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Close clone() => new Close()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Close create() => new Close();
  static PbList<Close> createRepeated() => new PbList<Close>();
  static Close getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyClose();
    return _defaultInstance;
  }
  static Close _defaultInstance;
  static void $checkItem(Close v) {
    if (v is !Close) checkItemFailed(v, 'Close');
  }

  String get reason => $_get(0, 1, '');
  set reason(String v) { $_setString(0, 1, v); }
  bool hasReason() => $_has(0, 1);
  void clearReason() => clearField(1);
}

class _ReadonlyClose extends Close with ReadonlyMessageMixin {}

