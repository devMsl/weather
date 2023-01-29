class SearchCityWeatherOb {
  Coord? coord;
  List<Weather>? weather;
  String? base;
  Main? main;
  String? visibility;
  Wind? wind;
  Rain? rain;
  Clouds? clouds;
  Snow? snow;
  String? dt;
  Sys? sys;
  String? timezone;
  String? id;
  String? name;
  String? cod;

  SearchCityWeatherOb({coord, weather, base, main, visibility, wind, rain, snow, clouds, dt, sys, timezone, id, name, cod});

  SearchCityWeatherOb.fromJson(Map<String, dynamic> json) {
    coord = json['coord'] != null ? Coord.fromJson(json['coord']) : null;
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather!.add(Weather.fromJson(v));
      });
    }
    base = json['base'];
    main = json['main'] != null ? Main.fromJson(json['main']) : null;
    visibility = json['visibility'].toString();
    wind = json['wind'] != null ? Wind.fromJson(json['wind']) : null;
    clouds = json['clouds'] != null ? Clouds.fromJson(json['clouds']) : null;
    rain = json['rain'] != null ? Rain.fromJson(json['rain']) : null;
    snow = json['snow'] != null ? Snow.fromJson(json['snow']) : null;
    dt = json['dt'].toString();
    sys = json['sys'] != null ? Sys.fromJson(json['sys']) : null;
    timezone = json['timezone'].toString();
    id = json['id'].toString();
    name = json['name'];
    cod = json['cod'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (coord != null) {
      data['coord'] = coord!.toJson();
    }
    if (weather != null) {
      data['weather'] = weather!.map((v) => v.toJson()).toList();
    }
    data['base'] = base;
    if (main != null) {
      data['main'] = main!.toJson();
    }
    data['visibility'] = visibility;
    if (wind != null) {
      data['wind'] = wind!.toJson();
    }
    if (rain != null) {
      data['rain'] = rain!.toJson();
    }
    if (snow != null) {
      data['snow'] = snow!.toJson();
    }
    if (clouds != null) {
      data['clouds'] = clouds!.toJson();
    }
    data['dt'] = dt;
    if (sys != null) {
      data['sys'] = sys!.toJson();
    }
    data['timezone'] = timezone;
    data['id'] = id;
    data['name'] = name;
    data['cod'] = cod;
    return data;
  }
}

class Coord {
  String? lon;
  String? lat;

  Coord({lon, lat});

  Coord.fromJson(Map<String, dynamic> json) {
    lon = json['lon'].toString();
    lat = json['lat'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lon'] = lon;
    data['lat'] = lat;
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

class Main {
  String? temp;
  String? feelsLike;
  String? tempMin;
  String? tempMax;
  String? pressure;
  String? humidity;
  String? seaLevel;
  String? grndLevel;

  Main({temp, feelsLike, tempMin, tempMax, pressure, humidity, grndLevel, seaLevel});

  Main.fromJson(Map<String, dynamic> json) {
    temp = json['temp'].toString();
    feelsLike = json['feels_like'].toString();
    tempMin = json['temp_min'].toString();
    tempMax = json['temp_max'].toString();
    pressure = json['pressure'].toString();
    humidity = json['humidity'].toString();
    seaLevel = json['sea_level'].toString();
    grndLevel = json['grnd_level'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['temp'] = temp;
    data['feels_like'] = feelsLike;
    data['temp_min'] = tempMin;
    data['temp_max'] = tempMax;
    data['pressure'] = pressure;
    data['humidity'] = humidity;
    data['sea_level'] = seaLevel;
    data['grnd_level'] = grndLevel;
    return data;
  }
}

class Wind {
  String? speed;
  String? deg;
  String? gust;

  Wind({speed, deg, gust});

  Wind.fromJson(Map<String, dynamic> json) {
    speed = json['speed'].toString();
    deg = json['deg'].toString();
    gust = json['gust'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['speed'] = speed;
    data['deg'] = deg;
    data['gust'] = gust;
    return data;
  }
}

class Rain {
  String? d1h;
  String? d3h;

  Rain({d1h, d3h});

  Rain.fromJson(Map<String, dynamic> json) {
    d1h = json['1h'].toString();
    d3h = json['3h'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['1h'] = d1h;
    data['3h'] = d3h;
    return data;
  }
}

class Snow {
  String? d1h;
  String? d3h;

  Snow({d1h, d3h});

  Snow.fromJson(Map<String, dynamic> json) {
    d1h = json['1h'].toString();
    d3h = json['3h'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['1h'] = d1h;
    data['3h'] = d3h;
    return data;
  }
}

class Clouds {
  String? all;

  Clouds({all});

  Clouds.fromJson(Map<String, dynamic> json) {
    all = json['all'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['all'] = all;
    return data;
  }
}

class Sys {
  String? type;
  String? id;
  String? country;
  String? message;
  String? sunrise;
  String? sunset;

  Sys({type, id, country, message, sunrise, sunset});

  Sys.fromJson(Map<String, dynamic> json) {
    type = json['type'].toString();
    id = json['id'].toString();
    country = json['country'];
    sunrise = json['sunrise'].toString();
    sunset = json['sunset'].toString();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    data['country'] = country;
    data['message'] = message;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    return data;
  }
}
