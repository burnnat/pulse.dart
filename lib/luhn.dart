library pulsefs.luhn;

import 'package:quiver/check.dart';

Alphabet base32 = new Alphabet('ABCDEFGHIJKLMNOPQRSTUVWXYZ234567');

class Alphabet {
  final String _alphabet;

  Alphabet(String contents)
    : this._alphabet = contents {

    Set<int> runes = new Set();
    bool unique = _alphabet.runes.every((rune) => runes.add(rune));

    checkArgument(unique, message: 'Alphabet characters must be unique.');
  }

  String generate(String s) {
    int factor = 1;
    int sum = 0;
    int n = _alphabet.length;

    // Note: Syncthing has a nonstandard implementation of Luhn mod N,
    // in which the input string is iterated forwards rather than backwards.
    // Normally, the loop would be constructed like this:
    // for (int i = s.length - 1; i >= 0; i--) {
    // As changing this would invalidate all pre-existing node IDs, however,
    // the incorrect implementation is left as-is. See discussion here:
    // https://discourse.syncthing.net/t/v0-9-0-new-node-id-format/478/5
    for (int i = 0; i < s.length; i++) {
      int codepoint = _alphabet.indexOf(s[i]);

      checkArgument(
        codepoint >= 0,
        message: 'Input string must not contain characters outside the given alphabet.'
      );

      int addend = factor * codepoint;
      factor = (factor == 2) ? 1 : 2;

      addend = (addend ~/ n) + (addend % n);
      sum += addend;
    }

    int remainder = sum % n;
    int checkCodepoint = (n - remainder) % n;

    return _alphabet[checkCodepoint];
  }

  bool validate(String s) {
    int lastIndex = s.length - 1;
    String data = s.substring(0, lastIndex);

    String check = generate(data);

    return s.substring(lastIndex) == check;
  }
}