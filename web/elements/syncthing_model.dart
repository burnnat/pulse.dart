library syncthing.elements.model;

import 'package:observe/observe.dart';

class DeviceModel extends Observable {
  @observable
  DeviceDetailsModel details = new DeviceDetailsModel('Device Name', 'V6UWXHU-4ACGLMP-RHBLWNB-OALS7TD-RPLB6GJ-774QU6D-ON5547H-Z7IRHA5');

  @observable
  String status = 'Disconnected';

  @observable
  bool mounted = true;
}

class DeviceDetailsModel extends Observable {
  @observable
  String name;

  @observable
  String id;

  DeviceDetailsModel.empty();

  DeviceDetailsModel.from(DeviceDetailsModel model) :
    this(model.name, model.id);

  DeviceDetailsModel(this.name, this.id);

  void commit(DeviceDetailsModel model) {
    this.name = model.name;
    this.id = model.id;
  }
}