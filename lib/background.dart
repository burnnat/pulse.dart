library syncthing.background;

import 'dart:async';
import 'dart:js';
import 'dart:html';

import 'package:chrome/chrome_app.dart' as chrome;
import 'package:observe/observe.dart';
import 'package:logging/logging.dart';

import 'device.dart';
import 'global.dart';

final Logger logger = new Logger('syncthing.background');

BackgroundStorage background;

abstract class ChromeBackgroundPage extends ChangeNotifier {
  static const String UPDATE_EVENT = 'globalUpdate';
  static const String UPDATE_KEY = 'key';
  static const String UPDATE_OLD_VALUE = 'oldValue';
  static const String UPDATE_NEW_VALUE = 'newValue';

  static Future<JsObject> getPage() =>
    chrome.runtime
      .getBackgroundPage()
      .then((page) {
        JsObject raw = page.toJs();

        try {
          return new JsObject.fromBrowserObject(raw);
        }
        catch (e) {
          return raw;
        }
      });

  final Map<Symbol, GlobalType> _types;
  final JsObject _page;

  ChromeBackgroundPage(this._page, this._types);

  @override
  void observed() {
    _page.callMethod('addEventListener', [UPDATE_EVENT, onGlobalUpdate]);
  }

  @override
  void unobserved() {
    _page.callMethod('removeEventListener', [UPDATE_EVENT, onGlobalUpdate]);
  }

  void onGlobalUpdate(CustomEvent e) {
    Symbol key = e.detail[UPDATE_KEY];
    logger.finer(() => 'Global property updated: $key');

    Object original = cast(key, e.detail[UPDATE_OLD_VALUE]);
    Object modified = cast(key, e.detail[UPDATE_NEW_VALUE]);

    notifyPropertyChange(key, original, modified);
  }

  void save(Symbol key, Object global) {
    JsObject value = _types[key].writeGlobal(global);

    CustomEvent event = new CustomEvent(
        UPDATE_EVENT,
        detail: {
          UPDATE_KEY: key,
          UPDATE_OLD_VALUE: _page[key],
          UPDATE_NEW_VALUE: value
        }
    );

    _page[key] = value;
    _page.callMethod('dispatchEvent', [event]);
  }

  dynamic retrieve(Symbol key) => cast(key, _page[key]);
  dynamic cast(Symbol key, JsObject raw) => _types[key].readGlobal(raw);
}

abstract class BackgroundStorage {
  LocalDevice device;
}

class SyncthingStorage extends ChromeBackgroundPage implements BackgroundStorage {
  static final Map<Symbol, GlobalType> _TYPES = {
    #device: LocalDevice.TYPE
  };

  static Future<BackgroundStorage> create() =>
    ChromeBackgroundPage.getPage()
      .then((page) => new SyncthingStorage._(page));

  SyncthingStorage._(JsObject page) : super(page, _TYPES);

  LocalDevice get device => retrieve(#device);
  void set device(LocalDevice device) => save(#device, device);
}
