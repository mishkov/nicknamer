import 'dart:math';

import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nicknamer/custom_toast/custom_toast.dart';
import 'package:nicknamer/services/admob_service.dart';
import 'package:nicknamer/services/app_localizations.dart';
import 'package:nicknamer/database/database.dart';
import 'package:nicknamer/services/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Admob.initialize();

  var theme = await DBProvider.db.getSetting('Theme');
  await ThemeController().load(theme);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Nicknamer',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English, no country code
        const Locale('ru', 'RU'), // Russian, no country code
        // ... other locales the app supports
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          print('supportedLocale.languageCode: ${supportedLocale.languageCode},'
              'locale.languageCode: ${locale.languageCode},'
              'supportedLocale.countryCode: ${supportedLocale.countryCode},'
              'locale.countryCode: ${locale.countryCode}');
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      home: MyHomePage(title: 'Nicknamer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _adMobService = AdMobService();
  final _originalNameController = TextEditingController();
  final _readyNicknameController = TextEditingController();
  final homePageKey = GlobalKey<ScaffoldState>();

  final Map<String, String> _lowercaseSymbols = {
    'а': 'a',
    'б': '6',
    'в': 'B',
    'г': 'r',
    'д': 'g',
    'е': 'e',
    'ё': 'e',
    'ж': '7K',
    'з': '3',
    'и': 'u',
    'й': 'u',
    'к': 'k',
    'л': 'Jl',
    'м': 'M',
    'н': 'H',
    'о': 'o',
    'п': 'TT',
    'р': 'p',
    'с': 'c',
    'т': 'T',
    'у': 'y',
    'ф': 'olo',
    'х': 'x',
    'ц': 'LL',
    'ч': '4',
    'ш': 'LLl',
    'щ': 'LLL',
    'ъ': 'b',
    'ы': 'bl',
    'ь': 'b',
    'э': '3',
    'ю': 'lo',
    'я': '9l',
    ' ': '_'
  };
  final Map<String, String> _uppercaseSymbols = {
    'а': 'A',
    'б': '6',
    'в': 'B',
    'г': 'r',
    'д': 'D',
    'е': 'E',
    'ё': 'E',
    'ж': '7K',
    'з': '3',
    'и': 'u',
    'й': 'u',
    'к': 'K',
    'л': 'Jl',
    'м': 'M',
    'н': 'H',
    'о': 'O',
    'п': 'TT',
    'р': 'P',
    'с': 'C',
    'т': 'T',
    'у': 'y',
    'ф': 'olo',
    'х': 'X',
    'ц': 'LL',
    'ч': '4',
    'ш': 'LLl',
    'щ': 'LLL',
    'ъ': 'b',
    'ы': 'bl',
    'ь': 'b',
    'э': '3',
    'ю': 'lo',
    'я': '9l',
    ' ': '_',
  };

  void onChangeThemeButtonClick() async {
    var currentTheme = await DBProvider.db.getSetting('Theme');
    var newTheme = ThemeController().getNextTheme(currentTheme);

    await DBProvider.db.setSetting('Theme', newTheme);

    await ThemeController().load(newTheme);

    if (newTheme == ThemeController.whiteTheme) {
      showToast(context,
          AppLocalizations.of(context).translate('white_mode_on_message'));
    } else if (newTheme == ThemeController.blackTheme) {
      showToast(context,
          AppLocalizations.of(context).translate('dark_mode_on_message'));
    } else {
      showToast(context,
          AppLocalizations.of(context).translate('android_theme_on_message'));
    }

    setState(() {});
  }

  void onCopyButtonClick() => Clipboard.setData(
        ClipboardData(
          text: _readyNicknameController.text,
        ),
      );

  void onTransformOtherButtonClick() =>
      generateReadyNameWithRandomSymbolCase(_originalNameController.text);

  void onOriginalNameChanged(String originalName) =>
      generateReadyName(originalName);

  void generateReadyName(String originalName) {
    String nickname = '';

    bool isNextSymbolInUppercase = false;
    for (var i = 0; i < originalName.length; i++) {
      var symbolInLowerCase = originalName[i].toLowerCase();
      if (_lowercaseSymbols.containsKey(symbolInLowerCase)) {
        if (isNextSymbolInUppercase) {
          nickname += _uppercaseSymbols[originalName[i]];
        } else {
          nickname += _lowercaseSymbols[originalName[i]];
        }
        isNextSymbolInUppercase = !isNextSymbolInUppercase;
      } else {
        nickname += originalName[i];
      }
    }

    _readyNicknameController.text = nickname;
  }

  void generateReadyNameWithRandomSymbolCase(String originalName) {
    String nickname = '';

    for (var i = 0; i < originalName.length; i++) {
      var symbolInLowerCase = originalName[i].toLowerCase();
      if (_lowercaseSymbols.containsKey(symbolInLowerCase)) {
        var isNextSymbolInUppercase = Random().nextBool();
        if (isNextSymbolInUppercase) {
          nickname += _uppercaseSymbols[originalName[i]];
        } else {
          nickname += _lowercaseSymbols[originalName[i]];
        }
      } else {
        nickname += originalName[i];
      }
    }

    _readyNicknameController.text = nickname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homePageKey,
      backgroundColor: ThemeController().getColor('background'),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: ThemeController().getColor('app_bar_text'),
          ),
        ),
        backgroundColor: ThemeController().getColor('app_bar'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.brightness_6,
              color: ThemeController().getColor('app_bar_button'),
            ),
            onPressed: onChangeThemeButtonClick,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 38),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: _originalNameController,
                      onChanged: onOriginalNameChanged,
                      style: TextStyle(
                        color:
                            ThemeController().getColor('text_form_input_text'),
                      ),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: ThemeController()
                                .getColor('text_form_input_text')),
                        labelText: AppLocalizations.of(context)
                            .translate('original_name_text_form_field'),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                ThemeController().getColor('text_form_input'),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 14, bottom: 46),
                      child: TextFormField(
                        controller: _readyNicknameController,
                        style: TextStyle(
                          color: ThemeController()
                              .getColor('text_form_input_text'),
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: ThemeController()
                                  .getColor('text_form_input_text')),
                          labelText: AppLocalizations.of(context)
                              .translate('ready_nickname_text_form_field'),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  ThemeController().getColor('text_form_input'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                          color: ThemeController()
                              .getColor('transform_other_button'),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('transform_other_button'),
                            style: TextStyle(
                              color: ThemeController()
                                  .getColor('transform_other_button_text'),
                            ),
                          ),
                          onPressed: onTransformOtherButtonClick,
                        ),
                        RaisedButton(
                          color: ThemeController().getColor('copy_button'),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('copy_button'),
                            style: TextStyle(
                              color: ThemeController()
                                  .getColor('copy_button_text'),
                            ),
                          ),
                          onPressed: onCopyButtonClick,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: AdmobBanner(
                adUnitId: _adMobService.getMainPageBannerAdId(),
                adSize: AdmobBannerSize.ADAPTIVE_BANNER(
                    width: MediaQuery.of(context).size.width.toInt()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
