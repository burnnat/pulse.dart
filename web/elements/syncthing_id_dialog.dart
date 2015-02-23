library syncthing.elements.id_dialog;

import 'package:polymer/polymer.dart';

import 'package:paper_elements/paper_action_dialog.dart';
import 'package:syncthing/device.dart';

@CustomTag('syncthing-id-dialog')
class SyncthingIdDialog extends PolymerElement {

  @published
  LocalDevice device;

  PaperActionDialog dialog;

  SyncthingIdDialog.created() : super.created();

  void attached() {
    dialog = $['dialog'];
  }

  void open() {
    dialog.open();
  }

  String formatDeviceId(LocalDevice device) =>
    device != null
      ? device.id.toString()
      : '';
}