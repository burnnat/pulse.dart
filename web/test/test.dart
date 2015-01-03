import 'luhn_test.dart' as luhn;
import 'message_test.dart' as message;
import 'message_discovery_test.dart' as message_discovery;
import 'xdr_test.dart' as xdr;

void runTests() {
  luhn.runTests();
  message.runTests();
  message_discovery.runTests();
  xdr.runTests();
}
