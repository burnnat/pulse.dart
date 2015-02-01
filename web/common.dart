library syncthing.common;

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:syncthing/background.dart';

Future initialize() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  new Logger('syncthing').info('Initializing...');

  return SyncthingStorage
    .create()
    .then((bg) {
      background = bg;
    });
}
