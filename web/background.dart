library pulsefs.background;

import 'package:logging/logging.dart';
import 'package:chrome/chrome_app.dart' as chrome;

final Logger logger = new Logger('pulsefs');

void main() {
  logger.info('Executing background script');

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
    ).then((createdWindow) {
      createdWindow.id = 'interface';
    });
  });
}
