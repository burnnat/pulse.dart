import 'dart:io';
import 'dart:isolate';

void main() {
  Directory dir = new File.fromUri(Platform.script).parent.parent;

  Link link = new Link('${dir.path}/web/test/packages');
  link.createSync('${dir.path}/packages');

  ReceivePort port = new ReceivePort();

  Isolate
    .spawnUri(
      Uri.parse('${dir.path}/web/test/test.dart'),
      ['testing'],
      port.sendPort
      // Rather than manually creating symlinks, the idiomatic
      // approach would be to use the 'packageRoot' argument:
      // packageRoot: Uri.parse('${dir.path}/packages')
      // Unfortunately, not all platforms support this.
    )
    .then((_) => port.first);

  link.deleteSync();
}
