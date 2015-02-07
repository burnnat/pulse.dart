library syncthing.protocol.xdr;

@MirrorsUsed(metaTargets: xdr)
import 'dart:mirrors';
import 'dart:typed_data';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:quiver/collection.dart';
import 'package:quiver/iterables.dart';

final Logger logger = new Logger('syncthing.protocol.xdr');

const Object xdr = const _Xdr();
class _Xdr {
  const _Xdr();
}

const Object transient = const _Transient();
class _Transient {
  static TypeMirror type = reflectClass(_Transient);
  const _Transient();
}

class XdrEncodingException implements Exception {
  final Object value;
  const XdrEncodingException(this.value);
  String toString() => 'Unable to encode value: $value';
}

abstract class XdrPayload {
  const XdrPayload();

  InstanceMirror _getMirror() => reflect(this);

  static Iterable<ClassMirror> _supertypes(TypeMirror type) =>
    new GeneratingIterable<ClassMirror>(
      () => type,
      (prev) => prev.superclass
    );

  static Iterable<VariableMirror> _dataFieldsFor(InstanceMirror mirror) =>
    _supertypes(mirror.type)
      .toList()
      // Reverse so superclass fields are added first
      .reversed
      .map((type) => type.declarations)
      .expand((declarations) =>
        declarations
          .values
          .where(
            (declaration) =>
              declaration is VariableMirror &&
              !declaration.isStatic &&
              !declaration.metadata.any(
                (annotation) => annotation.type == _Transient.type
              )
          )
      );

  static Object _instantiate(TypeMirror type, List<int> bytes) =>
    (type as ClassMirror)
      .newInstance(
        new Symbol('fromBytes'),
        [bytes]
      ).reflectee;

  bool _hasSupertype(TypeMirror target, TypeMirror reference) =>
    _supertypes(target).any((type) => type == reference);

  static String _nameFor(DeclarationMirror mirror) =>
    MirrorSystem.getName(mirror.simpleName);

  static Object _valueFor(InstanceMirror mirror, DeclarationMirror declaration) =>
      mirror.getField(declaration.simpleName).reflectee;

  XdrPayload.fromBytes(List<int> bytes) {
    InstanceMirror mirror = _getMirror();

    logger.finest(() => 'Parsing XDR payload of type: ${_nameFor(mirror.type)}');

    _dataFieldsFor(mirror)
      .forEach((declaration) {
        TypeMirror type = declaration.type;
        Object value;

        logger.finest(() => 'Parsing field ${_nameFor(declaration)} with type: ${_nameFor(type)}');

        // First check if the field is a list. Normally, we would use:
        // if (type.isSubtypeOf(reflectType(List))) {
        // However, dart2js does not yet support isSubtypeOf().
        if (type.originalDeclaration == reflectType(List).originalDeclaration) {
          Int length = new Int.fromBytes(bytes);
          TypeMirror elementType = type.typeArguments.first;

          logger.finest(() => 'Expecting ${length.value} elements of type: ${_nameFor(elementType)}');

          value = new List.generate(
            length.value,
            (index) => _instantiate(elementType, bytes)
          );
        }
        // Now check if the field is an XdrPayload. Again, we would normally use:
        // else if (type.isSubtypeOf(reflectType(XdrPayload))) {
        // However, to work with dart2js we need to walk the class tree manually.
        else if (_hasSupertype(type, reflectType(XdrPayload))) {
          value = _instantiate(type, bytes);
        }
        else {
          throw new XdrEncodingException(type);
        }

        mirror.setField(declaration.simpleName, value);
      });
  }

  ByteBuffer toBuffer() {
    return new Uint8List.fromList(toBytes()).buffer;
  }

  List<int> toBytes() {
    List<int> bytes = new List<int>();

    InstanceMirror mirror = _getMirror();

    _dataFieldsFor(mirror)
      .map((declaration) => _valueFor(mirror, declaration))
      .forEach((value) => addValue(bytes, value));

    return bytes;
  }

  void addValue(List<int> bytes, Object value) {
    if (value is XdrPayload) {
      bytes.addAll(value.toBytes());
    }
    else if (value is List<XdrPayload>) {
      addValue(bytes, new Int(value.length));
      value.forEach((item) => addValue(bytes, item));
    }
    else {
      throw new XdrEncodingException(value);
    }
  }

  @override
  String toString() {
    InstanceMirror mirror = _getMirror();

    String type = MirrorSystem.getName(mirror.type.simpleName);

    String fields = _dataFieldsFor(mirror)
      .map((declaration) {
        String name = _nameFor(declaration);
        Object value = _valueFor(mirror, declaration);
        return '$name=$value';
      })
      .join(', ');

    return '$type($fields)';
  }
}

int calculatePadding(int length) =>
  3 - ((length + 3) % 4);

List<int> pad(List<int> data) {
  int length = data.length;
  int padding = calculatePadding(length);

  if (padding == 0) {
    return data;
  }

  List<int> padded = new List<int>(length + padding);

  padded.setRange(0, length, data);
  padded.fillRange(length, padded.length, 0);

  return padded;
}

class Short extends XdrPayload {
  final int value;

  const Short(this.value);

  @override
  List<int> toBytes() {
    return pad([
      value >> 8,
      value
    ]);
  }
}

class Int extends XdrPayload {
  final int value;

  const Int(this.value);

  Int.fromBytes(List<int> bytes) :
    this.value = (
      bytes.removeAt(0) << 24 |
      bytes.removeAt(0) << 16 |
      bytes.removeAt(0) << 8  |
      bytes.removeAt(0)
    );

  @override
  List<int> toBytes() {
    return [
      value >> 24,
      value >> 16,
      value >> 8,
      value
    ];
  }

  @override
  String toString() => value.toString();

  operator ==(Int other) => (this.value == other.value);
}

class Hyper extends XdrPayload {
  Int upper;
  Int lower;

  Hyper(this.upper, this.lower);

  Hyper.fromBytes(List<int> bytes) : super.fromBytes(bytes);

  Hyper.forValue(int upper, int lower) :
    this.upper = new Int(upper),
    this.lower = new Int(lower);
}

abstract class VariablePayload extends XdrPayload {
  const VariablePayload();

  VariablePayload.fromBytes(List<int> bytes) {
    int length = new Int.fromBytes(bytes).value;
    logger.finest(() => 'Detected variable-length entry of size: $length');

    setData(bytes.sublist(0, length));
    bytes.removeRange(0, length + calculatePadding(length));
  }

  @override
  List<int> toBytes() {
    List<int> bytes = new List<int>();
    List<int> data = getData();

    addValue(bytes, new Int(data.length));
    bytes.addAll(pad(data));

    return bytes;
  }

  List<int> getData();
  void setData(List<int> data);
}

class Opaque extends VariablePayload {
  List<int> data;

  Opaque(this.data);
  Opaque.fromBytes(List<int> bytes) : super.fromBytes(bytes);

  @override
  List<int> getData() => data;

  @override
  void setData(List<int> data) {
    this.data = data;
  }

  operator ==(Opaque other) => listsEqual(this.data, other.data);
}

class XdrString extends VariablePayload {
  String value;

  XdrString(this.value);
  XdrString.fromBytes(List<int> bytes) : super.fromBytes(bytes);

  @override
  List<int> getData() {
    return UTF8.encode(value);
  }

  @override
  void setData(List<int> data) {
    this.value = UTF8.decode(data);
  }

  String toString() => value;
}
