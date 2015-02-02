import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'background_test.dart' as background;
import 'bep_test.dart' as bep;
import 'discovery_test.dart' as discovery;
import 'luhn_test.dart' as luhn;
import 'message_test.dart' as message;
import 'types_test.dart' as types;
import 'xdr_test.dart' as xdr;

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  useHtmlEnhancedConfiguration();
  unittestConfiguration.timeout = const Duration(seconds: 2);

  background.runTests();
  bep.runTests();
  discovery.runTests();
  luhn.runTests();
  message.runTests();
  types.runTests();
  xdr.runTests();
}
