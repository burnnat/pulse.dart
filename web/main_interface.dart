library syncthing.main_interface;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';

import 'common.dart' as common;

final Logger logger = new Logger('syncthing');

void main() {
  common
    .initialize()
    .then((_) {
      initPolymer();
    });
}
