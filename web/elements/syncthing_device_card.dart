library syncthing.elements.device_card;

import 'dart:html';

import 'package:polymer/polymer.dart';

import 'syncthing_model.dart';

@CustomTag('syncthing-device-card')
class SyncthingDeviceCard extends PolymerElement {

  @published
  DeviceModel device;

  SyncthingDeviceCard.created() : super.created();

  void fireEdit(Event e, var detail, Node target) {
    fire('edit');
  }
}