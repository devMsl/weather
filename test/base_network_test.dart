import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:weather/model/weather_ob.dart';
import 'package:weather/utils/base_network.dart';

void main() {
  group('Test weather ob', () {
    test('Fetch weather data', () async {
      final baseNetwork = BaseNetwork();
      baseNetwork.client = MockClient((request) async {
        final jsonMap = {
          "lat": 37.7858,
          "lon": -122.4064,
          "timezone": "America/Los_Angeles",
          "timezone_offset": -28800,
          "current": {
            "dt": 1645284904,
            "sunrise": 1645282470,
            "sunset": 1645321962,
            "temp": 10,
            "feels_like": 8.44,
            "pressure": 1020,
            "humidity": 75,
            "dew_point": 5.78,
            "uvi": 0.45,
            "clouds": 0,
            "visibility": 10000,
            "wind_speed": 3.13,
            "wind_deg": 110,
            "wind_gust": 4.47,
            "weather": [
              {"id": 800, "main": "Clear", "description": "clear sky", "icon": "01d"}
            ]
          }
        };
        return Response(json.encode(jsonMap), 200);
      });
      final data = await baseNetwork.getRequest(url: 'onecall?lat=37.785834&lon=-122.406417&exclude=minutely,hourly,daily&units=metric&appid=3bb78a7b58f5640266bc1d05069a60ec');
      Map<String, dynamic> map = json.decode(data.data);
      WeatherOb weatherOb = WeatherOb.fromJson(map);
      expect(weatherOb.lat.toString(), '37.7858');
    });
  });
}
