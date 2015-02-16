library syncthing.elements.model;

import 'package:observe/observe.dart';

class DeviceModel extends Observable {
  @observable
  String name = 'Device Name';

  @observable
  String status = 'Disconnected';

  @observable
  bool mounted = true;
}
