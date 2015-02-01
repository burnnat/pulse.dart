library syncthing.elements.log;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';

@CustomTag('syncthing-log')
class SyncthingLog extends PolymerElement {

  final List<String> messages = toObservable([]);

  SyncthingLog.created() : super.created() {
    Logger.root.onRecord.listen((LogRecord rec) {
      messages.add('${rec.level.name}: ${rec.time}: ${rec.message}');
    });
  }
}