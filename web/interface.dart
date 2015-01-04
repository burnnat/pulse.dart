library pulsefs.interface;

import 'dart:html';
import 'dart:js';

import 'package:logging/logging.dart';
import 'package:pulsefs/discovery.dart';
import 'test/test_html.dart';

final Logger logger = new Logger('pulsefs');

void main() {
  Logger.root.onRecord.listen((LogRecord rec) {
    String message = '${rec.level.name}: ${rec.time}: ${rec.message}';
    querySelector('#logs').appendHtml('<div>$message</div>');
  });

  if (context['id'] == 'test') {
    querySelector('#root').remove();
    runHtmlTests();
  }
  else {
    Discoverer discoverer = new ChainedDiscoverer([
      new LocalDiscoverer(21025),
      new GlobalDiscoverer('announce.syncthing.net', 22026)
    ]);

    DeviceId id = new DeviceId('MEUFKLW-DSKHAZM-IRZBSBW-U6RE65I-SHLD7AF-VQY2OVU-LYEXABO-F53URAM');

    querySelector('#send-request').onClick.listen((event) {
      logger.info('Button click detected');

      discoverer
        .locate(id)
        .then((address) => logger.info('Located address: $address'));
    });
  }
}
