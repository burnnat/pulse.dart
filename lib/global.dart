library syncthing.global;

import 'dart:js';

abstract class GlobalType<T> {
  T fromJs(JsObject object);
  JsObject toJs(T object);
}

abstract class Global<T> {
  GlobalType<T> get type;
}
