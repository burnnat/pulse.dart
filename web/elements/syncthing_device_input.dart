library syncthing.elements.device_input;

import 'package:polymer/polymer.dart';

@CustomTag('syncthing-device-input')
class SyncthingDeviceInput extends PolymerElement {

  @published
  String value;

  SyncthingDeviceInput.created() : super.created();
}