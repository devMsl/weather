import 'package:flutter/material.dart';

class BuildThemeData {
//   ThemeData lightTheme(String str, Locale locale) {
//     return ThemeData(
//       inputDecorationTheme: InputDecorationTheme(
//         fillColor: Colors.white.withOpacity(.9),
//         prefixStyle: TextStyle(
//           color: Colors.blue,
//         ),
//         labelStyle: TextStyle(
//           color: Colors.grey,
//         ),
//         hintStyle: TextStyle(
//           color: Color(0xff747d8c),
//         ),
//       ),
//       fontFamily: str,
//       dividerColor: Colors.blueGrey,
//       primaryColor: Colors.lightBlue, //Color(0xFF191979),
//       appBarTheme: AppBarTheme(elevation: 0),
//       canvasColor: Colors.white, //Color(0xFFffffff),
//       cardColor: Colors.white,
//       scaffoldBackgroundColor: Colors.grey.shade100,
//       cursorColor: Colors.blue,
//
//       buttonTheme: ButtonThemeData(
//           textTheme: ButtonTextTheme.primary,
//           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
// //            buttonColor: Theme.of(context).cursorColor,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
//       cardTheme: CardTheme(
//         elevation: 0,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//       ),
//       bottomNavigationBarTheme: BottomNavigationBarThemeData(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey.shade400,
//       ),
//       textTheme: TextTheme(
//         caption: TextStyle(
//           fontSize: 14,
//           color: Colors.blue,
//           fontFamily: str,
//           fontWeight: FontWeight.w600,
//           locale: locale,
//         ),
//         headline1: TextStyle(
//           fontSize: 17,
//           color: Colors.white,
//           fontFamily: str,
//           fontWeight: FontWeight.w600,
//           locale: locale,
//         ),
//         headline2: TextStyle(
//           fontSize: 12,
//           color: Colors.white,
//           fontFamily: str,
//           locale: locale,
//         ),
//         headline3: TextStyle(fontSize: 17, color: Colors.black, fontFamily: str, fontWeight: FontWeight.bold, locale: locale),
//         headline4: TextStyle(fontSize: 17, color: Colors.black87, fontFamily: str, fontWeight: FontWeight.w600, locale: locale),
//         headline5: TextStyle(fontSize: 15, color: Colors.black, fontFamily: str, fontWeight: FontWeight.bold, locale: locale),
//         headline6: TextStyle(fontSize: 14, color: Colors.white, fontFamily: str, locale: locale),
//         bodyText1: TextStyle(fontSize: 14, color: Colors.black87, fontFamily: str, locale: locale),
//         bodyText2: TextStyle(
//           fontSize: 14,
//           color: Colors.blueGrey,
//           fontFamily: str,
//           locale: locale,
//         ),
//         subtitle1: TextStyle(fontSize: 12, color: Colors.blueGrey, fontFamily: str, locale: locale),
//         subtitle2: TextStyle(fontSize: 14, color: Colors.blueGrey, fontWeight: FontWeight.bold, fontFamily: str, locale: locale), //decoration: TextDecoration.lineThrough
//       ),
//     );
//   }

  ThemeData lightTheme(String str, Locale locale) {
    return ThemeData(
      // appBarTheme: AppBarTheme(
      //   color: Color(0xff192734), //Color(0xff1e272e),
      //   elevation: 0,
      //   brightness: Brightness.dark,
      // ),
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
      // brightness: Brightness.dark,
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
