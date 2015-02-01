library syncthing.elements.app;

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';

import 'package:syncthing/background.dart';
import 'package:syncthing/device.dart';

final Logger logger = new Logger('syncthing.app');

@CustomTag('syncthing-app')
class SyncthingApp extends PolymerElement {

  @observable
  BackgroundStorage globals;

  SyncthingApp.created() : super.created() {
    globals = background;
  }

  void generateDevice(Event event, Object detail, Node sender) {
    LocalDevice.fromStorage().then((device) => globals.device = device);
  }

  void logMessage(Event event, Object detail, Node sender) {
    logger.info("Test log messages");
  }

  String formatDeviceId(LocalDevice device) =>
    device != null
      ? device.id.toString()
      : '[none set]';
}