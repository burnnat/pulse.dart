library syncthing.elements.app;

import 'package:polymer/polymer.dart';
import 'package:syncthing/background.dart';
import 'syncthing_model.dart';

@CustomTag('syncthing-app')
class SyncthingApp extends PolymerElement {

  @observable
  BackgroundStorage globals;

  @observable
  List<String> devices = toObservable([
    new DeviceModel()
  ]);

  SyncthingApp.created() : super.created() {
    globals = background;
  }
}