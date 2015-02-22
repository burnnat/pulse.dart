library syncthing.elements.device_dialog;

import 'package:polymer/polymer.dart';

import 'package:paper_elements/paper_action_dialog.dart';

import 'syncthing_model.dart';

@CustomTag('syncthing-device-dialog')
class SyncthingDeviceDialog extends PolymerElement {

  @published
  DeviceDetailsModel details;

  @published
  bool editing;

  PaperActionDialog dialog;

  bool get opened => dialog.opened;

  SyncthingDeviceDialog.created() : super.created();

  void attached() {
    dialog = $['dialog'];
  }

  void add() {
    editing = false;
    details = new DeviceDetailsModel.empty();
    dialog.open();
  }

  void edit(DeviceModel device) {
    editing = true;
    details = device.details;
    dialog.open();
  }
}