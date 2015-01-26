library syncthing.handler;

import 'dart:js';

import 'package:logging/logging.dart';
import 'package:chrome/chrome_app.dart' as chrome;

final Logger logger = new Logger('syncthing.handler');

typedef void EventHandler(JsObject options, JsFunction success, JsFunction error);

class FilesystemHandler {
  static JsObject _initProvider() => context['chrome']['fileSystemProvider'];
  final JsObject provider;

  FilesystemHandler() : this.provider = _initProvider();

  void register() {
    if (provider == null) {
      return;
    }

    _register('onUnmountRequested', _unmount);
    _register('onGetMetadataRequested', _getMetadata);
    _register('onReadDirectoryRequested', _readDirectory);
    _register('onReadFileRequested', _readFile);
    _register('onAbortRequested', _abort);
  }

  void _register(String eventName, EventHandler handler) {
    JsObject event = new JsObject.fromBrowserObject(provider[eventName]);
    event.callMethod('addListener', [
      (JsObject options, JsFunction success, JsFunction error) {
        logger.fine('Event: $eventName');
        String rendered = context['JSON'].callMethod('stringify', [options]);
        logger.fine('Options: $rendered');
        Function.apply(handler, [options, success, error]);
      }
    ]);
  }

  JsObject _entryMeta(
    bool isDirectory, String name,
    { int size: 0, DateTime modified: null }) {

    return new JsObject.jsify({
      'isDirectory': isDirectory,
      'name': name,
      'size': size,
      'modificationTime': modified != null ? modified : new DateTime.now()
    });
  }

  void _getMetadata(JsObject options, JsFunction success, JsFunction error) {
    success.apply([
      _entryMeta(true, 'Name')
    ]);
  }

  void _readDirectory(JsObject options, JsFunction success, JsFunction error) {
    success.apply([
      new JsArray.from([]),
      false
    ]);
  }

  void _readFile(JsObject options, JsFunction success, JsFunction error) {

  }

  void _abort(JsObject options, JsFunction success, JsFunction error) {
    success.apply([]);
  }

  void _unmount(JsObject options, JsFunction success, JsFunction error) {
    context['chrome']['fileSystemProvider'].callMethod('unmount', [
      new JsObject.jsify({
        'fileSystemId': options['fileSystemId']
      }),
      () {
        if (chrome.runtime.lastError != null) {
          logger.severe('Unmount failed: ${chrome.runtime.lastError.message}');
          error.apply(['FAILED']);
        }
        else {
          logger.info('Unmount succeeded');
          success.apply([]);
        }
      }
    ]);
  }
}
