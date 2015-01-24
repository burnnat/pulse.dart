library pulsefs.background;

import 'package:logging/logging.dart';
import 'package:chrome/chrome_app.dart' as chrome;

import 'package:pulsefs/device.dart';
import 'package:pulsefs/handler.dart';

final Logger logger = new Logger('pulsefs');

LocalDevice device;

void main() {
  logger.info('Executing background script');

  LocalDevice
    .fromStorage()
    .then((loaded) {
      device = loaded;
    });

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
