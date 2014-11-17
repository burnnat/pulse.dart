import 'package:unittest/html_enhanced_config.dart';
import 'message_test.dart' as message;

void runTests() {
    useHtmlEnhancedConfiguration();
    message.runTests();
}