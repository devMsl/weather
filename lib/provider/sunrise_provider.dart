import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SunriseProvider extends ChangeNotifier {
  bool isSunrise = true;

  checkSunrise(bool isSun) {
    isSunrise = isSun;
    notifyListeners();
  }
}
