import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather/utils/shared_pref.dart';

class TemperatureProvider extends ChangeNotifier {
  String unit = 'metric';
  List<Map<String, dynamic>> cordList = [];
//  Unit temperature = Unit.metric;

  saveCityCord(Map<String, dynamic> myMap) {
    cordList.add(myMap);
    print('cordList $cordList');
    notifyListeners();
  }

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
//    unit = value - 273.15;
    SharedPref.setData(key: SharedPref.unit, value: 'metric');
    unit = 'metric';
    notifyListeners();
  }

//9/5 (K - 273) + 32
  changeToFahrenheit() {
//    unit = 9 / 5 * (value - 273) + 32;
    SharedPref.setData(key: SharedPref.unit, value: 'imperial');
    unit = 'imperial';
    notifyListeners();
  }
}
