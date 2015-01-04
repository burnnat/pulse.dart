import 'dart:js';

import 'package:logging/logging.dart';

import 'background.dart' as background;
import 'interface.dart' as interface;

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  // This value is set by the accompanying script, background.js
  if (context['isBackground']) {
    background.main();
  }
  else {
    interface.main();
  }
}
