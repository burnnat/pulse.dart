library syncthing.background_test;

import 'dart:async';
import 'dart:js';

import 'package:observe/observe.dart';
import 'package:syncthing/background.dart';
import 'package:syncthing/global.dart';
import 'package:quiver/core.dart';
import 'package:unittest/unittest.dart';

void runTests() {
  group('Background storage', () {
    TestStorage storage;

    setUp(() =>
      TestStorage.create()
        .then((created) => storage = created));

    test('stores and retrieves objects', () {
      TestObject original = new TestObject('Joe Schmoe', 36);
      storage.test = original;

      TestObject retrieved = storage.test;

      expect(retrieved, equals(original));
    });

    group('observes', () {
      TestObject original;
      StreamSubscription subscription;

      setUp(() {
        original = storage.test = new TestObject('Uncle Sam', 239);
      });

      tearDown(() => subscription.cancel());

      test('change events', () {
        TestObject modified = new TestObject('Jane Doe', 22);

        subscription = storage.changes.listen(
          expectAsync((List<ChangeRecord> records) {
            expect(records.length, equals(1));
            PropertyChangeRecord record = records.first;

            expect(record.object, equals(storage));
            expect(record.name, equals(#test));
            expect(record.oldValue, equals(original));
            expect(record.newValue, equals(modified));
          })
        );

        storage.test = modified;
      });

      test('remove events', () {
        subscription = storage.changes.listen(
          expectAsync((List<ChangeRecord> records) {
            expect(records.length, equals(1));
            PropertyChangeRecord record = records.first;

            expect(record.object, equals(storage));
            expect(record.name, equals(#test));
            expect(record.oldValue, equals(original));
            expect(record.newValue, equals(null));
          })
        );

        storage.test = null;
      });
    });
  });
}

class TestStorage extends ChromeBackgroundPage {
  static final Map<Symbol, GlobalType> _TYPES = {
    #test: TestObject.TYPE
  };

  static Future<TestStorage> create() =>
    ChromeBackgroundPage.getPage()
      .then((page) => new TestStorage._(page));

  TestStorage._(JsObject page) : super(page, _TYPES);

  TestObject get test => retrieve(#test);
  void set test(TestObject device) => save(#test, device);
}

class TestObject {
  static const GlobalType<TestObject> TYPE = const TestType();

  final String name;
  final int age;

  TestObject(this.name, this.age);

  bool operator ==(o) =>
    o is TestObject
      && this.name == o.name
      && this.age == o.age;

  int get hashCode => hash2(name, age);
}

class TestType extends GlobalType<TestObject> {
  static const String _NAME = 'name';
  static const String _AGE = 'age';

  const TestType();

  TestObject fromJs(JsObject object) =>
    new TestObject(object[_NAME], object[_AGE]);

  JsObject toJs(TestObject object) => new JsObject.jsify({
    _NAME: object.name,
    _AGE: object.age
  });
}
