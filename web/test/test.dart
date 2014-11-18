import 'dart:isolate';

import 'package:unittest/unittest.dart' as unittest;
import 'message_test.dart' as message;

void runTests() {
  message.runTests();
}

class WaitConfiguration extends unittest.SimpleConfiguration {
  final SendPort port;

  WaitConfiguration(this.port);

  void onDone(bool passed) {
    super.onDone(passed);
    port.send(passed);
  }
}

void main(List<String> args, SendPort port) {
  unittest.unittestConfiguration = new WaitConfiguration(port);
  runTests();
}