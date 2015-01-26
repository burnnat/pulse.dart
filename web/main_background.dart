library pulsefs.main_background;

import 'dart:js';

import 'package:logging/logging.dart';
import 'package:chrome/chrome_app.dart' as chrome;

import 'package:pulsefs/background.dart';
import 'package:pulsefs/device.dart';
import 'package:pulsefs/handler.dart';

final Logger logger = new Logger('pulsefs');

void main() {
  logger.info('Executing background script');

  LocalDevice
    .fromStorage()
    .then((device) => background.device = device);

  new FilesystemHandler().register();

  chrome.app.runtime.onLaunched.listen((launchData) {
    chrome.app.window.create(
      'index.html',
      new chrome.CreateWindowOptions(
        id: 'dart',
        bounds: new chrome.ContentBounds(
          width: 800,
          height: 600
        )
      )
    );
  });
}
