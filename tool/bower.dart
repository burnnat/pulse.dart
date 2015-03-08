import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:path/path.dart';
import 'package:quiver/async.dart';

// Platform-independent newline
String n = Platform.isWindows ? '\r\n' : '\n';

String directory;
List<String> excludes;

void main(List<String> args) {
  FutureGroup group = new FutureGroup();

  group.add(readJson('.bowerrc'));
  group.add(readJson('bower.json'));

  group.future.then((futures) {
    directory = futures[0]['directory'];
    excludes = futures[1]['ignoredDependencies'];

    args.forEach((package) => postinstall(package));
  });
}

Future<dynamic> readJson(String path) =>
  new File(path)
    .readAsString()
    .then((data) => JSON.decode(data));

void postinstall(String package) {
  Directory root = new Directory(directory + '/' + package);

  if (excludes.contains(package)) {
    root.deleteSync(recursive: true);
  }

  switch (package) {
    case 'ajax-form':
      deleteExcept(root, ['ajax-form.html', 'ajax-form.js']);
      updateFile(
        root,
        'ajax-form.html',
        (lines) {
          lines.insert(0, '<!DOCTYPE html>');
          lines[1] = '<link rel="import" href="../../packages/polymer/polymer.html">';
        }
      );
      break;

    case 'qr-code':
      updateFile(
        root,
        'src/qr-code.html',
        (lines) {
          lines.insert(0, '<!DOCTYPE html>');
          lines.insert(1, '<link rel="import" href="../../packages/polymer/polymer.html">');
        }
      );
      break;

    default:
      break;
  }
}

void deleteExcept(Directory root, List<String> keep) {
  // Always keep the package description and cache files.
  keep.add('.bower.json');
  keep.add('bower.json');

  root
    .listSync(
        recursive: false,
        followLinks: false
    )
    .where((child) => !keep.contains(basename(child.path)))
    .forEach((child) => child.deleteSync(recursive: true));
}

typedef void Updater(List<String> lines);

void updateFile(Directory root, String filename, Updater updater) {
  File file = new File(root.path + '/' + filename);

  List<String> lines = file.readAsLinesSync();
  updater(lines);

  String data = lines.reduce((a, b) => a + n + b);
  file.writeAsString(data);
}