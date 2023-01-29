import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/model/weather_ob.dart';
import 'package:weather/provider/sunrise_provider.dart';
import 'package:weather/provider/temperature_provider.dart';
import 'package:weather/utils/shared_pref.dart';
import 'package:weather/view/page/search_city_page.dart';
import 'package:weather/view/page/weather_detail_page.dart';
import 'package:weather/view/widgets/loading_widget.dart';

import '../../model/response_ob.dart';
import '../../utils/app_constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Location location = Location();

  bool _serviceEnabled = false;
  bool isSunrise = true;
  bool? serviceEnabled;
  bool isLoading = false;

  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  WeatherOb? _weatherOb;

  late WeatherBloc _bloc;
  List<String>? timeZone;

  String? city;
  String? temperature;

  int selectedUnit = 1;
  int selectedLang = 1;

  Future<LocationData?> _determinePosition() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        _locationData = await location.getLocation();

        return _locationData;
      }
    } else if (_permissionGranted == PermissionStatus.granted) {
      _locationData = await location.getLocation();

      return _locationData;
    }
    return null;
  }

  @override
  void initState() {
    SharedPref.getData(key: SharedPref.language).then((lan) {
      if (lan == 'en' || lan == null || lan == '') {
        selectedLang = 1;
      } else if (lan == 'my') {
        selectedLang = 2;
      } else {
        selectedLang = 1;
      }
    });
    context.read<TemperatureProvider>().checkTemperatureUnit();
    _determinePosition().then((value) {
      _bloc = WeatherBloc('onecall?lat=${value!.latitude}&lon=${value.longitude}&exclude=minutely,hourly,daily&units=${context.read<TemperatureProvider>().unit}&appid=$appId');
      _bloc.getWeatherData();
      _bloc.getWeatherStream().listen((event) {
        if (event.responseState == ResponseState.loading) {}
        if (event.responseState == ResponseState.data) {
          _weatherOb = event.data;
          temperature = _weatherOb!.current!.temp ?? '';
          if (int.parse(_weatherOb!.current!.dt!) == int.parse(_weatherOb!.current!.sunrise!) ||
              ((int.parse(_weatherOb!.current!.dt!) > int.parse(_weatherOb!.current!.sunrise!) && int.parse(_weatherOb!.current!.dt!) < int.parse(_weatherOb!.current!.sunset!)))) {
            context.read<SunriseProvider>().checkSunrise(true);
          } else {
            context.read<SunriseProvider>().checkSunrise(false);
          }

          setState(() {});
          timeZone = _weatherOb!.timezone!.split('/');
          city = timeZone![1].replaceAll('_', ' ');
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _weatherOb == null || isLoading == true
          ? LoadingWidget()
          : Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: context.read<SunriseProvider>().isSunrise ? const AssetImage('assets/sunrise.JPG') : const AssetImage('assets/sunset.JPG'), fit: BoxFit.fill)),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 40, 5, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'weather',
                            style: Theme.of(context).textTheme.headline2,
                          ).tr(),
                        ),
                        // const Spacer(),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return SearchByCityPage();
                              }));
                            },
                            icon: const Icon(
                              CupertinoIcons.search,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return WeatherDetailPage(
                          _locationData!.latitude.toString(),
                          _locationData!.longitude.toString(),
                        );
                      }));
                    },
                    child: Card(
                      margin: const EdgeInsets.all(5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.compass,
                                      color: Colors.blueGrey,
                                    ),
                                    Text(
                                      ' At your current location',
                                      style: Theme.of(context).textTheme.bodyText2,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  city ?? '',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  DateFormat('j').format(
                                    DateTime.fromMillisecondsSinceEpoch(int.parse(_weatherOb!.timezoneOffset!) * 1000, isUtc: true),
                                  ),
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                            Text(
                              '$temperature ${context.watch<TemperatureProvider>().unit == 'metric' ? '\u2103' : '\u2109'}',
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 30),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedLang = 1;
                                  SharedPref.setData(key: SharedPref.language, value: 'en');
                                  context.setLocale(const Locale('en'));
                                });
                              },
                              child: Text(
                                ' EN ',
                                style: selectedLang == 1 ? Theme.of(context).textTheme.headline4 : Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                            Text(
                              '|',
                              style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 22, fontWeight: FontWeight.normal),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedLang = 2;
                                  SharedPref.setData(key: SharedPref.language, value: 'my');
                                  context.setLocale(const Locale('my'));
                                });
                              },
                              child: Text(
                                ' MM ',
                                style: selectedLang == 2 ? Theme.of(context).textTheme.headline4 : Theme.of(context).textTheme.bodyText2,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedUnit = 1;
                                  SharedPref.setData(key: SharedPref.unit, value: 'metric');
                                  context.read<TemperatureProvider>().changeToCelsius();
                                  _bloc = WeatherBloc(
                                      'onecall?lat=${_locationData!.latitude.toString()}&lon=${_locationData!.longitude.toString()}&exclude=minutely,hourly,daily&units=${context.read<TemperatureProvider>().unit}&appid=$appId');
                                  _bloc.getWeatherData();
                                  _bloc.getWeatherStream().listen((event) {
                                    if (event.responseState == ResponseState.data) {
                                      isLoading = true;
                                      setState(() {});
                                    }
                                    if (event.responseState == ResponseState.data) {
                                      _weatherOb = event.data;
                                      temperature = _weatherOb!.current!.temp ?? '';
                                      timeZone = _weatherOb!.timezone!.split('/');
                                      city = timeZone![1].replaceAll('_', ' ');
                                      isLoading = false;

                                      setState(() {});
                                    }
                                  });
                                });
                              },
                              child: Text(
                                ' Celsius ',
                                style: selectedUnit == 1 ? Theme.of(context).textTheme.headline4 : Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                            Text(
                              '|',
                              style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 22, fontWeight: FontWeight.normal),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedUnit = 2;
                                  SharedPref.setData(key: SharedPref.unit, value: 'imperial');
                                  context.read<TemperatureProvider>().changeToFahrenheit();
                                  _bloc = WeatherBloc(
                                      'onecall?lat=${_locationData!.latitude.toString()}&lon=${_locationData!.longitude.toString()}&exclude=minutely,hourly,daily&units=${context.read<TemperatureProvider>().unit}&appid=$appId');
                                  _bloc.getWeatherData();
                                  _bloc.getWeatherStream().listen((event) {
                                    if (event.responseState == ResponseState.data) {
                                      isLoading = true;
                                      setState(() {});
                                    }
                                    if (event.responseState == ResponseState.data) {
                                      _weatherOb = event.data;
                                      temperature = _weatherOb!.current!.temp ?? '';
                                      timeZone = _weatherOb!.timezone!.split('/');
                                      city = timeZone![1].replaceAll('_', ' ');
                                      isLoading = false;

                                      setState(() {});
                                    }
                                  });
                                });
                              },
                              child: Text(
                                ' Fahrenheit ',
                                style: selectedUnit == 2 ? Theme.of(context).textTheme.headline4 : Theme.of(context).textTheme.bodyText2,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
