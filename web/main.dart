import 'dart:html';
import 'dart:js';

import 'package:chrome/chrome_app.dart' as chrome;
import 'test/test.dart';

void main() {
  if (context['id'] == 'test') {
    querySelector('#root').remove();
    runTests();
  }
  else {
    querySelector('#send-request').onClick.listen(sendRequest);
  }
}

void sendRequest(MouseEvent event) {
  querySelector('#logs').appendHtml('<div>Test</div>');
}
