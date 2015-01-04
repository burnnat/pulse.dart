library pulsefs.handler;

import 'dart:js';

import 'package:logging/logging.dart';

final Logger logger = new Logger('pulsefs.handler');

typedef void EventHandler(JsObject options, JsFunction success, JsFunction error);

class FilesystemHandler {
  static JsObject _initProvider() => context['chrome']['fileSystemProvider'];
  final JsObject provider;

  FilesystemHandler() : this.provider = _initProvider();

  void register() {
    _register('onGetMetadataRequested', _getMetadata);
    _register('onReadDirectoryRequested', _readDirectory);
    _register('onReadFileRequested', _readFile);
    _register('onAbortRequested', _abort);
  }

  void _register(String eventName, EventHandler handler) {
    provider[eventName].callMethod('addListener', [
      (JsObject options, JsFunction success, JsFunction error) {
        logger.fine('Event: $eventName');
        Function.apply(handler, [options, success, error]);
      }
    ]);
  }

  void _getMetadata(JsObject options, JsFunction success, JsFunction error) {

  }

  void _readDirectory(JsObject options, JsFunction success, JsFunction error) {

  }

  void _readFile(JsObject options, JsFunction success, JsFunction error) {

  }

  void _abort(JsObject options, JsFunction success, JsFunction error) {

  }
}