import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildThemeData {
  ThemeData lightTheme(String str, Locale locale) {
    return ThemeData(
      textTheme: TextTheme(
        caption: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600, fontFamily: str, locale: locale),
        headline1: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w600, fontFamily: str, locale: locale),
        headline2: TextStyle(fontSize: 20, color: Colors.white, fontFamily: str, locale: locale),
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
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
      indicatorColor: const Color(0xFFFFFFee),
      dividerColor: Colors.grey.shade300,
      inputDecorationTheme: const InputDecorationTheme(
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
