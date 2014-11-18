import 'dart:isolate';

import 'package:unittest/unittest.dart' as unittest;

import 'message_test.dart' as message;
import 'xdr_test.dart' as xdr;

void runTests() {
  message.runTests();
  xdr.runTests();
}

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