import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildThemeData {
  ThemeData lightTheme(String str, Locale locale) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white, // <-- SEE HERE
          statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness: Brightness.dark, //<-- For iOS SEE HERE (dark icons)
        ),
      ),
      // useMaterial3: true,
      textTheme: TextTheme(
        caption: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600, fontFamily: str, locale: locale),
        headline1: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w600, fontFamily: str, locale: locale),
        headline2: TextStyle(fontSize: 12, color: Colors.white, fontFamily: str, locale: locale),
        headline3: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: str, locale: locale),
        headline4: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600, fontFamily: str, locale: locale),
        headline5: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600, fontFamily: str, locale: locale),
        headline6: TextStyle(fontSize: 15, color: Colors.white, fontFamily: str, locale: locale),
        bodyText1: TextStyle(fontSize: 14, color: Colors.white, fontFamily: str, locale: locale),
        bodyText2: TextStyle(fontSize: 14, color: Colors.white70, fontFamily: str, locale: locale),
        subtitle1: TextStyle(fontSize: 14, color: Colors.white60, fontFamily: str, locale: locale),
      ),
      cardTheme: CardTheme(
        color: Colors.black54,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      fontFamily: str,
      scaffoldBackgroundColor: Colors.blueGrey,
      cursorColor: Colors.blue,
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      accentColor: Colors.blue,
      buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
      indicatorColor: Color(0xFFFFFFee),
      dividerColor: Colors.grey.shade300,
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Color(0xff1e272e),
        prefixStyle: TextStyle(
          color: Colors.blue,
        ),
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
