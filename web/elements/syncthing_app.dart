library syncthing.elements.app;

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';

import 'package:syncthing/background.dart';
import 'package:syncthing/device.dart';
import 'package:syncthing/bep.dart';
import 'package:syncthing/discovery.dart';

final Logger logger = new Logger('syncthing.app');

@CustomTag('syncthing-app')
class SyncthingApp extends PolymerElement {

  @observable
  BackgroundStorage globals;

  @observable
  String deviceId;

  @observable
  String address = '127.0.0.1';

  @observable
  String port = '22000';

  SyncthingApp.created() : super.created() {
    globals = background;
  }

  void loadLocalDevice(Event event, Object detail, Node sender) {
    LocalDevice.fromStorage().then((device) => globals.device = device);
  }

  void resolveDevice(Event event, Object detail, Node sender) {
      logger.info('Sending discovery query');

      Discoverer discoverer = new ChainedDiscoverer([
        new LocalDiscoverer(21025),
        new GlobalDiscoverer('announce.syncthing.net', 22026)
      ]);

      discoverer
        .locate(new DeviceId(deviceId))
        .then((address) {
          logger.info('Located address: $address');
        })
        .then((_) => discoverer.close());
  }

  void connectDevice(Event event, Object detail, Node sender) {
    new BlockSocket(globals.device)
      .connectToAddress(new Address(new IP.v4(address), new Int(int.parse(port))));
  }

  String formatDeviceId(LocalDevice device) =>
    device != null
      ? device.id.toString()
      : '[none set]';
}