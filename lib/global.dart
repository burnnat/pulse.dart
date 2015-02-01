library syncthing.global;

import 'dart:js';

abstract class GlobalType<T> {

  const GlobalType();

  T readGlobal(JsObject object) =>
    object != null
      ? fromJs(object)
      : null;

  JsObject writeGlobal(T object) =>
    object != null
      ? toJs(object)
      : null;

  T fromJs(JsObject object);
  JsObject toJs(T object);
}
