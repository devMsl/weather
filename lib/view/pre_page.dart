import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
    return EasyLocalization(child: MyApp(), fallbackLocale: const Locale('en'), supportedLocales: const [Locale('en'), Locale('my')], path: 'lang');
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final BuildThemeData _buildThemeData = BuildThemeData();
  static String fontFamily = "Pyidaungsu";

  @override
  void initState() {
    super.initState();
    SharedPref.getData(key: SharedPref.language).then((lan) {
      if (lan == 'en' || lan == null || lan == '') {
        fontFamily = "Pyidaungsu";
        context.setLocale(const Locale('en'));
      } else if (lan == 'my') {
        fontFamily = "Pyidaungsu";
        context.setLocale(const Locale('my'));
      } else {
        fontFamily = "Pyidaungsu";
        context.setLocale(const Locale('en'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildThemeData.lightTheme(fontFamily, context.locale),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: HomePage(),
    );
  }
}
