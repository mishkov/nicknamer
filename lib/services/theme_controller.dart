import 'dart:convert';
import 'dart:ui';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class ThemeController {
  static final ThemeController _controller = ThemeController._internal();
  factory ThemeController() => _controller;
  ThemeController._internal();

  Map<String, String> _colors;
  static final autoTheme = 'Auto';
  static final whiteTheme = 'White';
  static final blackTheme = 'Black';
  final List<String> _availableThemes = [autoTheme, whiteTheme, blackTheme];

  Future<bool> load(String theme) async {
    assert(_availableThemes.contains(theme));
    theme = theme.toLowerCase();
    String jsonString;
    if (theme == 'auto') {
      var brightness = SchedulerBinding.instance.window.platformBrightness;
      if (brightness == Brightness.dark) {
        jsonString =
            await rootBundle.loadString('themes/black_theme_colors.json');
      } else {
        jsonString =
            await rootBundle.loadString('themes/white_theme_colors.json');
      }
    } else {
      jsonString =
          await rootBundle.loadString('themes/${theme}_theme_colors.json');
    }
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _colors = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  num get themeOptionsCount => _availableThemes.length;

  //return copy of list
  List<String> get themes => List<String>.from(_availableThemes);

  Color getColor( String key ) =>
      Color( int.parse( _colors[ key ].substring( 2 ), radix: 16 ) );

  String getNextTheme( String theme ) {
    final previousThemeIndex = _availableThemes.indexOf( theme );
    final nextThemeIndex = previousThemeIndex + 1;

    if ( nextThemeIndex < _availableThemes.length ) {
      return _availableThemes[ nextThemeIndex ];
    } else {
      return _availableThemes.first;
    }
  }
}
