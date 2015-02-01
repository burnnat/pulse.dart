library syncthing.main_background;

import 'package:logging/logging.dart';
import 'package:chrome/chrome_app.dart' as chrome;

import 'package:syncthing/background.dart';
import 'package:syncthing/device.dart';
import 'package:syncthing/handler.dart';

import 'common.dart' as common;

final Logger logger = new Logger('syncthing');

void main() {
  common
    .initialize()
    .then((_) {
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
    });
}
