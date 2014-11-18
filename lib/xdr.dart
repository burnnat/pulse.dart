library pulsefs.xdr;

import 'dart:mirrors';
import 'dart:typed_data';
import 'dart:convert';

class XdrEncodingException implements Exception {
  final Object value;

  const XdrEncodingException(this.value);

  String toString() => 'Unable to encode value: $value';
}

abstract class XdrPayload {
  const XdrPayload();

  ByteBuffer toBuffer() {
    return new Uint8List.fromList(toBytes()).buffer;
  }

  List<int> toBytes() {
    List<int> bytes = new List<int>();

    InstanceMirror mirror = reflect(this);
    dynamic declarations = mirror.type.declarations;

    declarations.keys
      .where((symbol) {
        DeclarationMirror mirror = declarations[symbol];
        return mirror is VariableMirror && !mirror.isStatic;
      })
      .map((symbol) => mirror.getField(symbol).reflectee)
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

  List<int> pad(List<int> data) {
    int length = data.length;
    int padding = 4 - (length % 4);

    if (padding < 4) {
      data.length = length + padding;
      data.fillRange(length, data.length, 0);
    }

    return data;
  }
}

class Short extends XdrPayload {
  final int value;

  const Short(this.value);

  @override
  List<int> toBytes() {
    return pad([
      value >> 16,
      value
    ]);
  }
}

class Int extends XdrPayload {
  final int value;

  const Int(this.value);

  @override
  List<int> toBytes() {
    return [
      value >> 24,
      value >> 16,
      value >> 8,
      value
    ];
  }
}

class Hyper extends XdrPayload {
  final Int upper;
  final Int lower;

  const Hyper(this.upper, this.lower);

  Hyper.forValue(int upper, int lower) :
    this.upper = new Int(upper),
    this.lower = new Int(lower);
}

abstract class VariablePayload extends XdrPayload {
  const VariablePayload();

  @override
  List<int> toBytes() {
    List<int> bytes = new List<int>();
    List<int> data = getData();

    addValue(bytes, new Int(data.length));
    bytes.addAll(pad(data));

    return bytes;
  }

  List<int> getData();
}

class Opaque extends VariablePayload {
  final List<int> data;

  const Opaque(this.data);

  @override
  List<int> getData() => data;
}

class XdrString extends VariablePayload {
  final String value;

  const XdrString(this.value);

  @override
  List<int> getData() {
    return UTF8.encode(value);
  }
}