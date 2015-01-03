import 'dart:isolate';

import 'package:unittest/unittest.dart' as unittest;
import '../web/test/test.dart';

class WaitConfiguration extends unittest.SimpleConfiguration {
  final SendPort port;

  WaitConfiguration(this.port);

  void onDone(bool passed) {
    try {
      super.onDone(passed);
    }
    finally {
      port.send(passed);
    }
  }
}

void main(List<String> args, SendPort port) {
  unittest.unittestConfiguration = new WaitConfiguration(port);
  runTests();
}