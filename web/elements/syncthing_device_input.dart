library syncthing.elements.device_input;

import 'package:polymer/polymer.dart';

@CustomTag('syncthing-device-input')
class SyncthingDeviceInput extends PolymerElement {

  @observable
  String value;

  SyncthingDeviceInput.created() : super.created();
}