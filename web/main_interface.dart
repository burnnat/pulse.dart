library syncthing.main_interface;

//import 'dart:html';
//import 'dart:js';

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
//import 'package:chrome/chrome_app.dart' as chrome;
//
//import 'package:syncthing/background.dart';
//import 'package:syncthing/bep.dart';
//import 'package:syncthing/discovery.dart';

//import 'test/test_html.dart';

import 'common.dart' as common;

final Logger logger = new Logger('syncthing');

void main() {
  common
    .initialize()
    .then((_) {
      initPolymer();
    });

//  Logger.root.onRecord.listen((LogRecord rec) {
//    String message = '${rec.level.name}: ${rec.time}: ${rec.message}';
//    querySelector('#logs').appendHtml('<div>$message</div>');
//  });
//
//  if (context['id'] == 'test') {
//    querySelector('#root').remove();
//    runHtmlTests();
//  }
//  else {
//    String idString = 'MEUFKLW-DSKHAZM-IRZBSBW-U6RE65I-SHLD7AF-VQY2OVU-LYEXABO-F53URAM';
//
//    querySelector('#mount-device').onClick.listen((event) {
//      logger.info('Mounting device: $idString');
//
//      context['chrome']['fileSystemProvider'].callMethod('mount', [
//        new JsObject.jsify({
//          'fileSystemId': idString,
//          'displayName': 'ARBOL',
//          'writable': false
//        }),
//        () {
//          if (chrome.runtime.lastError != null) {
//            logger.severe('Mount failed: ${chrome.runtime.lastError.message}');
//          }
//          else {
//            logger.info('Mount succeeded');
//          }
//        }
//      ]);
//    });
//
//    querySelector('#send-request').onClick.listen((event) {
//      logger.info('Sending discovery query');
//
////      Discoverer discoverer = new ChainedDiscoverer([
////        new LocalDiscoverer(21025),
////        new GlobalDiscoverer('announce.syncthing.net', 22026)
////      ]);
////
////      discoverer
////        .locate(new DeviceId(idString))
////        .then((address) {
////          logger.info('Located address: $address');
////          return new BlockSocket(background.device)..connectToAddress(address);
////        })
////        .then((_) => discoverer.close());
//      new BlockSocket(background.device).connectToAddress(new Address(new IP.v4('127.0.0.1'), new Int(22000)));
//    });
//  }
}
