import 'dart:math' as math;

import 'lowercase_symbols.dart';
import 'uppercase_symbols.dart';

class NickMaker {
  static final instance = NickMaker._internal();

  factory NickMaker() => instance;

  NickMaker._internal();

  String generateRandom(String source) {
    String nickname = '';

    for (var i = 0; i < source.length; i++) {
      var symbolInLowerCase = source[i].toLowerCase();

      if (_isSymbolConvertable(symbolInLowerCase)) {
        var isSymbolInUppercase = math.Random().nextBool();

        if (isSymbolInUppercase) {
          nickname += uppercaseSymbols[symbolInLowerCase];
        } else {
          nickname += lowercaseSymbols[symbolInLowerCase];
        }
      } else {
        nickname += source[i];
      }
    }

    return nickname;
  }

  bool _isSymbolConvertable(String symbol) {
    final isConvertableToLowercase = lowercaseSymbols.containsKey(symbol);
    final isConvertableToUppercase = uppercaseSymbols.containsKey(symbol);

    return isConvertableToLowercase && isConvertableToUppercase;
  }
}
