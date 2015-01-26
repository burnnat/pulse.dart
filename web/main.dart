import 'dart:js';

import 'package:logging/logging.dart';
import 'package:syncthing/background.dart';

import 'main_background.dart' as main_background;
import 'main_interface.dart' as main_interface;

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  ChromeBackground
    .create()
    .then((bg) {
      background = bg;

      // This value is set by the accompanying script, background.js
      if (context['isBackground']) {
        main_background.main();
      }
      else {
        main_interface.main();
      }
    });
}
