library syncthing.elements.device_dialog;

import 'package:polymer/polymer.dart';

import 'package:paper_elements/paper_action_dialog.dart';

import 'syncthing_model.dart';

@CustomTag('syncthing-device-dialog')
class SyncthingDeviceDialog extends PolymerElement {

  @published
  DeviceDetailsModel details;

  @published
  DeviceDetailsModel working;

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
    init();
  }

  void edit(DeviceModel device) {
    editing = true;
    details = device.details;
    init();
  }

  void init() {
    working = new DeviceDetailsModel.from(details);
    dialog.open();
  }

  void save() {
    details.commit(working);
  }
}