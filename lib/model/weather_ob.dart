class WeatherOb {
  String? lat;
  String? lon;
  String? timezone;
  String? timezoneOffset;
  Current? current;

  WeatherOb({lat, lon, timezone, timezoneOffset, current});

  WeatherOb.fromJson(Map<String, dynamic> json) {
    lat = json['lat'].toString();
    lon = json['lon'].toString();
    timezone = json['timezone'].toString();
    timezoneOffset = json['timezone_offset'].toString();
    current = json['current'] != null ? Current.fromJson(json['current']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lon'] = lon;
    data['timezone'] = timezone;
    data['timezone_offset'] = timezoneOffset;
    if (current != null) {
      data['current'] = current!.toJson();
    }
    return data;
  }
}

class Current {
  String? dt;
  String? sunrise;
  String? sunset;
  String? temp;
  String? feelsLike;
  String? pressure;
  String? humidity;
  String? dewPoint;
  String? uvi;
  String? clouds;
  String? visibility;
  String? windSpeed;
  String? windDeg;
  String? windGust;
  List<Weather>? weather;

  Current({dt, sunrise, sunset, temp, feelsLike, pressure, humidity, dewPoint, uvi, clouds, visibility, windSpeed, windDeg, windGust, weather});

  Current.fromJson(Map<String, dynamic> json) {
    dt = json['dt'].toString();
    sunrise = json['sunrise'].toString();
    sunset = json['sunset'].toString();
    temp = json['temp'].toString();
    feelsLike = json['feels_like'].toString();
    pressure = json['pressure'].toString();
    humidity = json['humidity'].toString();
    dewPoint = json['dew_point'].toString();
    uvi = json['uvi'].toString();
    clouds = json['clouds'].toString();
    visibility = json['visibility'].toString();
    windSpeed = json['wind_speed'].toString();
    windDeg = json['wind_deg'].toString();
    windGust = json['wind_gust'].toString();
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather!.add(Weather.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dt'] = dt;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    data['temp'] = temp;
    data['feels_like'] = feelsLike;
    data['pressure'] = pressure;
    data['humidity'] = humidity;
    data['dew_point'] = dewPoint;
    data['uvi'] = uvi;
    data['clouds'] = clouds;
    data['visibility'] = visibility;
    data['wind_speed'] = windSpeed;
    data['wind_deg'] = windDeg;
    data['wind_gust'] = windGust;
    if (weather != null) {
      data['weather'] = weather!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Weather {
  String? id;
  String? main;
  String? description;
  String? icon;

  Weather({id, main, description, icon});

  Weather.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['main'] = main;
    data['description'] = description;
    data['icon'] = icon;
    return data;
  }
}
