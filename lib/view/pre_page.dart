import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/provider/theme_provider.dart';
import 'package:weather/utils/shared_pref.dart';
import 'package:weather/view/page/home_page.dart';
import 'package:weather/view/widgets/theme.dart';

class PrePage extends StatefulWidget {
  @override
  _PrePageState createState() => _PrePageState();
}

class _PrePageState extends State<PrePage> {
  @override
  Widget build(BuildContext context) {
    return EasyLocalization(child: MyApp(), fallbackLocale: Locale('en'), supportedLocales: [Locale('en'), Locale('my')], path: 'lang');
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BuildThemeData _buildThemeData = BuildThemeData();
  static String fontFamily = "Pyidaungsu";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPref.getData(key: SharedPref.language).then((lan) {
      if (lan == 'en' || lan == null || lan == '') {
        fontFamily = "Pyidaungsu";
        context.setLocale(Locale('en'));
      } else if (lan == 'my') {
        fontFamily = "Pyidaungsu";
        context.setLocale(Locale('my'));
      } else {
        fontFamily = "Pyidaungsu";
        context.setLocale(Locale('en'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, ThemeProvider themeProvider, child) {
      return MaterialApp(
        themeMode: themeProvider.themeMode,
        theme: _buildThemeData.lightTheme(fontFamily, context.locale),
        // darkTheme: _buildThemeData.darkTheme(fontFamily, context.locale),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: HomePage(),
      );
    });
  }
}
