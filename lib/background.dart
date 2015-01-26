library syncthing.background;

import 'dart:async';
import 'dart:js';

import 'package:chrome/chrome_app.dart' as chrome;

import 'device.dart';
import 'global.dart';

BackgroundStorage background;

abstract class BackgroundStorage {
  LocalDevice device;
}

class ChromeBackground implements BackgroundStorage {
  final JsObject _page;

  static Future<BackgroundStorage> create() =>
    chrome.runtime
      .getBackgroundPage()
      .then((page) => new ChromeBackground._(new JsObject.fromBrowserObject(page.toJs())));

  ChromeBackground._(this._page);

  LocalDevice get device => _retrieve('device', LocalDevice.TYPE);
  void set device(LocalDevice device) => _save('device', device);

  void _save(String key, Global global) {
    _page[key] = global.type.toJs(global);
  }

  dynamic _retrieve(String key, GlobalType type) => type.fromJs(_page[key]);
}
