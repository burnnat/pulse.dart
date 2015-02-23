library syncthing.elements.app;

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:syncthing/background.dart';
import 'package:syncthing/device.dart';

import 'syncthing_device_card.dart';
import 'syncthing_device_dialog.dart';
import 'syncthing_id_dialog.dart';
import 'syncthing_model.dart';

@CustomTag('syncthing-app')
class SyncthingApp extends PolymerElement {

  @observable
  BackgroundStorage globals;

  @observable
  List<String> devices = toObservable([
    new DeviceModel()
  ]);

  SyncthingIdDialog idDialog;
  SyncthingDeviceDialog deviceDialog;

  SyncthingApp.created() : super.created() {
    globals = background;
  }

  void attached() {
    LocalDevice
      .fromStorage()
      .then((device) => background.device = device);

    idDialog = $['id-dialog'];
    deviceDialog = $['device-dialog'];
  }

  void showDeviceId(Event e, var detail, Node target) {
    idDialog.open();
  }

  void addDevice(Event e, var detail, Node target) {
    deviceDialog.add();
  }

  void editDevice(Event e, var detail, SyncthingDeviceCard target) {
    deviceDialog.edit(target.device);
  }
}