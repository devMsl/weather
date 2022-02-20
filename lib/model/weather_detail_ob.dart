class WeatherDetailOb {
  String? lat;
  String? lon;
  String? timezone;
  String? timezoneOffset;
  Current? current;
  List<Hourly>? hourly;
  List<Daily>? daily;

  WeatherDetailOb({lat, lon, timezone, timezoneOffset, current, hourly, daily});

  WeatherDetailOb.fromJson(Map<String, dynamic> json) {
    lat = json['lat'].toString();
    lon = json['lon'].toString();
    timezone = json['timezone'].toString();
    timezoneOffset = json['timezone_offset'].toString();
    current = json['current'] != null ? Current.fromJson(json['current']) : null;
    if (json['hourly'] != null) {
      hourly = <Hourly>[];
      json['hourly'].forEach((v) {
        hourly!.add(Hourly.fromJson(v));
      });
    }
    if (json['daily'] != null) {
      daily = <Daily>[];
      json['daily'].forEach((v) {
        daily!.add(Daily.fromJson(v));
      });
    }
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
    if (hourly != null) {
      data['hourly'] = hourly!.map((v) => v.toJson()).toList();
    }
    if (daily != null) {
      data['daily'] = daily!.map((v) => v.toJson()).toList();
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
  Rain? rain;

  Current({dt, sunrise, sunset, temp, feelsLike, pressure, humidity, dewPoint, uvi, clouds, visibility, windSpeed, windDeg, windGust, weather, rain});

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
    rain = json['rain'] != null ? Rain.fromJson(json['rain']) : null;
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
    if (rain != null) {
      data['rain'] = rain!.toJson();
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

class Hourly {
  String? dt;
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
  String? pop;

  Hourly({dt, temp, feelsLike, pressure, humidity, dewPoint, uvi, clouds, visibility, windSpeed, windDeg, windGust, weather, pop});

  Hourly.fromJson(Map<String, dynamic> json) {
    dt = json['dt'].toString();
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
    pop = json['pop'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dt'] = dt;
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
    data['pop'] = pop;
    return data;
  }
}

class Daily {
  String? dt;
  String? sunrise;
  String? sunset;
  String? moonrise;
  String? moonset;
  String? moonPhase;
  Temp? temp;
  FeelsLike? feelsLike;
  String? pressure;
  String? humidity;
  String? dewPoint;
  String? windSpeed;
  String? windDeg;
  String? windGust;
  List<Weather>? weather;
  String? clouds;
  String? pop;
  String? uvi;
  String? rain;

  Daily({dt, sunrise, sunset, moonrise, moonset, moonPhase, temp, feelsLike, pressure, humidity, dewPoint, windSpeed, windDeg, windGust, weather, clouds, pop, uvi, rain});

  Daily.fromJson(Map<String, dynamic> json) {
    dt = json['dt'].toString();
    sunrise = json['sunrise'].toString();
    sunset = json['sunset'].toString();
    moonrise = json['moonrise'].toString();
    moonset = json['moonset'].toString();
    moonPhase = json['moon_phase'].toString();
    temp = json['temp'] != null ? Temp.fromJson(json['temp']) : null;
    feelsLike = json['feels_like'] != null ? FeelsLike.fromJson(json['feels_like']) : null;
    pressure = json['pressure'].toString();
    humidity = json['humidity'].toString();
    dewPoint = json['dew_point'].toString();
    windSpeed = json['wind_speed'].toString();
    windDeg = json['wind_deg'].toString();
    windGust = json['wind_gust'].toString();
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather!.add(Weather.fromJson(v));
      });
    }
    clouds = json['clouds'].toString();
    pop = json['pop'].toString();
    uvi = json['uvi'].toString();
    rain = json['rain'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dt'] = dt;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    data['moonrise'] = moonrise;
    data['moonset'] = moonset;
    data['moon_phase'] = moonPhase;
    if (temp != null) {
      data['temp'] = temp!.toJson();
    }
    if (feelsLike != null) {
      data['feels_like'] = feelsLike!.toJson();
    }
    data['pressure'] = pressure;
    data['humidity'] = humidity;
    data['dew_point'] = dewPoint;
    data['wind_speed'] = windSpeed;
    data['wind_deg'] = windDeg;
    data['wind_gust'] = windGust;
    if (weather != null) {
      data['weather'] = weather!.map((v) => v.toJson()).toList();
    }
    data['clouds'] = clouds;
    data['pop'] = pop;
    data['uvi'] = uvi;
//    data['rain'] =  rain;
    return data;
  }
}

class Temp {
  String? day;
  String? min;
  String? max;
  String? night;
  String? eve;
  String? morn;

  Temp({day, min, max, night, eve, morn});

  Temp.fromJson(Map<String, dynamic> json) {
    day = json['day'].toString();
    min = json['min'].toString();
    max = json['max'].toString();
    night = json['night'].toString();
    eve = json['eve'].toString();
    morn = json['morn'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['min'] = min;
    data['max'] = max;
    data['night'] = night;
    data['eve'] = eve;
    data['morn'] = morn;
    return data;
  }
}

class FeelsLike {
  String? day;
  String? night;
  String? eve;
  String? morn;

  FeelsLike({day, night, eve, morn});

  FeelsLike.fromJson(Map<String, dynamic> json) {
    day = json['day'].toString();
    night = json['night'].toString();
    eve = json['eve'].toString();
    morn = json['morn'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['night'] = night;
    data['eve'] = eve;
    data['morn'] = morn;
    return data;
  }
}

class Rain {
  String? d1h;

  Rain({d1h});

  Rain.fromJson(Map<String, dynamic> json) {
    d1h = json['1h'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['1h'] = d1h;
    return data;
  }
}
