import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather/utils/shared_pref.dart';

class TemperatureProvider extends ChangeNotifier {
  String unit = 'metric';
  List<Map<String, dynamic>> cordList = [];

  checkTemperatureUnit() {
    SharedPref.getData(key: SharedPref.unit).then((value) {
      if (value != null || value != 'null') {
        if (value == 'metric') {
          unit = 'metric';
          notifyListeners();
        } else if (value == 'imperial') {
          unit = 'imperial';
          notifyListeners();
        } else {
          unit = 'metric';
          notifyListeners();
        }
      }
    });
  }

  changeToCelsius() {
    SharedPref.setData(key: SharedPref.unit, value: 'metric');
    unit = 'metric';
    notifyListeners();
  }

  changeToFahrenheit() {
    SharedPref.setData(key: SharedPref.unit, value: 'imperial');
    unit = 'imperial';
    notifyListeners();
  }
}
