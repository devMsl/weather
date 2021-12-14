class WeatherOb {
  String? lat;
  String? lon;
  String? timezone;
  String? timezoneOffset;
  Current? current;

  WeatherOb({this.lat, this.lon, this.timezone, this.timezoneOffset, this.current});

  WeatherOb.fromJson(Map<String, dynamic> json) {
    lat = json['lat'].toString();
    lon = json['lon'].toString();
    timezone = json['timezone'].toString();
    timezoneOffset = json['timezone_offset'].toString();
    current = json['current'] != null ? Current.fromJson(json['current']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['timezone'] = this.timezone;
    data['timezone_offset'] = this.timezoneOffset;
    if (this.current != null) {
      data['current'] = this.current!.toJson();
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

  Current(
      {this.dt,
      this.sunrise,
      this.sunset,
      this.temp,
      this.feelsLike,
      this.pressure,
      this.humidity,
      this.dewPoint,
      this.uvi,
      this.clouds,
      this.visibility,
      this.windSpeed,
      this.windDeg,
      this.windGust,
      this.weather});

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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['dt'] = this.dt;
    data['sunrise'] = this.sunrise;
    data['sunset'] = this.sunset;
    data['temp'] = this.temp;
    data['feels_like'] = this.feelsLike;
    data['pressure'] = this.pressure;
    data['humidity'] = this.humidity;
    data['dew_point'] = this.dewPoint;
    data['uvi'] = this.uvi;
    data['clouds'] = this.clouds;
    data['visibility'] = this.visibility;
    data['wind_speed'] = this.windSpeed;
    data['wind_deg'] = this.windDeg;
    data['wind_gust'] = this.windGust;
    if (this.weather != null) {
      data['weather'] = this.weather!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Weather {
  String? id;
  String? main;
  String? description;
  String? icon;

  Weather({this.id, this.main, this.description, this.icon});

  Weather.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['main'] = this.main;
    data['description'] = this.description;
    data['icon'] = this.icon;
    return data;
  }
}
