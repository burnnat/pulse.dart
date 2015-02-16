library syncthing.elements.device_card;

import 'package:polymer/polymer.dart';

import 'syncthing_model.dart';

@CustomTag('syncthing-device-card')
class SyncthingDeviceCard extends PolymerElement {

  @published
  DeviceModel device;

  SyncthingDeviceCard.created() : super.created();
}