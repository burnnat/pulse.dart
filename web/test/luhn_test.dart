library pulse.luhn_test;

import 'package:pulsefs/luhn.dart';
import 'package:unittest/unittest.dart';

void runTests() {
  group('Luhn check', () {
    test('handles base 6', () {
      Alphabet a = new Alphabet('abcdef');
      expect(a.generate('abcdef'), equals('e'));
    });

    test('handles base 10', () {
      Alphabet a = new Alphabet('0123456789');
      expect(a.generate('7992739871'), equals('3'));
    });

    test('handles invalid input', () {
      Alphabet a = new Alphabet('ABC');
      expect(() => a.generate('7992739871'), throws);
    });

    test('handles invalid alphabet', () {
      expect(() => new Alphabet('01234566789'), throws);
    });

    test('handles validation', () {
      Alphabet a = new Alphabet('abcdef');
      expect(a.validate('abcdefe'), isTrue);
      expect(a.validate('abcdefd'), isFalse);
    });
  });
}
