import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/model/respone_ob.dart';
import 'package:weather/model/weather_ob.dart';
import 'package:weather/provider/sunrise_provider.dart';
import 'package:weather/provider/temperature_provider.dart';
import 'package:weather/utils/app_constants.dart';
import 'package:weather/utils/shared_pref.dart';
import 'package:weather/view/page/search_city_page.dart';
import 'package:weather/view/page/weather_detail_page.dart';
import 'package:weather/view/widgets/loading_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late WeatherBloc _bloc;
//  late AnimationController _animationController;

  WeatherOb? _weatherOb;
  bool? serviceEnabled;
  LocationPermission? permission;
  Position? position;
  List<String>? timeZone;
  String? city;
  bool isSunrise = true;
  int selectedUnit = 1;
  int selectedLang = 1;
  String? temperature;
  bool isLoading = false;

  Future<Position?> _determinePosition() async {
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled!) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.whileInUse) {
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).catchError((e) {
        print(e);
      });
    }
    return null;
  }

  // void checkTempUnit() {
  //   SharedPref.getData(key: SharedPref.unit).then((rv) {
  //     if (rv == "metric") {
  //       setState(() {
  //         selectedUnit = 'metric';
  //       });
  //     } else if (rv == "imperial") {
  //       setState(() {
  //         selectedUnit = 'imperial';
  //       });
  //     } else {
  //       setState(() {
  //         selectedUnit = 'metric';
  //       });
  //     }
  //   });
  // }

  @override
  void initState() {
    // checkLanguage();
    // checkTempUnit();
    context.read<TemperatureProvider>().checkTemperatureUnit();

    _determinePosition().then((value) {
      position = value;
      _bloc = WeatherBloc(
          'onecall?lat=${position!.latitude.toString()}&lon=${position!.longitude.toString()}&exclude=minutely,hourly,daily&units=${context.read<TemperatureProvider>().unit}&appid=$APP_ID');
      _bloc.getWeatherData();
      _bloc.getWeatherStream().listen((event) {
        if (event.responseState == ResponseState.loading) {}
        if (event.responseState == ResponseState.data) {
          _weatherOb = event.data;
          temperature = _weatherOb!.current!.temp ?? '';
          if (int.parse(_weatherOb!.current!.dt!) == int.parse(_weatherOb!.current!.sunrise!) &&
              (int.parse(_weatherOb!.current!.dt!) > int.parse(_weatherOb!.current!.sunrise!) && int.parse(_weatherOb!.current!.dt!) < int.parse(_weatherOb!.current!.sunset!))) {
            // isSunrise = true;
            context.read<SunriseProvider>().checkSunrise(true);
          } else
            context.read<SunriseProvider>().checkSunrise(false);
          // isSunrise = false;

          setState(() {});
          timeZone = _weatherOb!.timezone!.split('/');
          city = timeZone![1].replaceAll('_', ' ');
        }
      });
    });
    super.initState();

//    List grid = [
//      [".", ".", ".", "1", "4", ".", ".", "2", "."],
//      [".", ".", "6", ".", ".", ".", ".", ".", "."],
//      [".", ".", ".", ".", ".", ".", ".", ".", "."],
//      [".", ".", "1", ".", ".", ".", ".", ".", "."],
//      [".", "6", "7", ".", ".", ".", ".", ".", "9"],
//      [".", ".", ".", ".", ".", ".", "8", "1", "."],
//      [".", "3", ".", ".", ".", ".", ".", ".", "6"],
//      [".", ".", ".", ".", ".", "7", ".", ".", "."],
//      [".", ".", ".", "5", ".", ".", ".", "7", "."]
//    ];
//    print(grid.length);
//    print(grid[0].length);
//    outerloop:
//    for (int row = 0; row < 9; row++) {
//      for (int col = 0; col < 9; col++) {
//        if (col == grid.length - 1) {
//        } else {
//          if (grid[row][col] == grid[row][col + 1]) {
//            print('false');
//            break outerloop;
//          } else {
//            print('true');
//          }
//        }
//      }
//    }

//    print(solve());
  }

//  List grid = [
//    [".", ".", ".", "1", "4", ".", ".", "2", "."],
//    [".", ".", "6", ".", ".", ".", ".", ".", "."],
//    [".", ".", ".", ".", ".", ".", ".", ".", "."],
//    [".", ".", "1", ".", ".", ".", ".", ".", "."],
//    [".", "6", "7", ".", ".", ".", ".", ".", "9"],
//    [".", ".", ".", ".", ".", ".", "8", "1", "."],
//    [".", "3", ".", ".", ".", ".", ".", ".", "6"],
//    [".", ".", ".", ".", ".", "7", ".", ".", "."],
//    [".", ".", ".", "5", ".", ".", ".", "7", "."]
//  ];
//  // we check if a possible number is already in a row
//  bool isInRow(int row, String number) {
//    for (int i = 0; i < 9; i++) if (grid[row][i] == number) return true;
//
//    return false;
//  }
//
//  // we check if a possible number is already in a column
//  bool isInCol(int col, String number) {
//    for (int i = 0; i < 9; i++) if (grid[i][col] == number) return true;
//
//    return false;
//  }
//
//  // we check if a possible number is in its 3x3 box
//  bool isInBox(int row, int col, String number) {
//    int r = row - row % 3;
//    int c = col - col % 3;
//
//    for (int i = r; i < r + 3; i++) for (int j = c; j < c + 3; j++) if (grid[i][j] == number) return true;
//
//    return false;
//  }
//
//  // combined method to check if a number possible to a row,col position is ok
//  bool isOk(int row, int col, String number) {
//    return !isInRow(row, number) && !isInCol(col, number) && !isInBox(row, col, number);
//  }
//
//  bool solve() {
//    for (int row = 0; row < 9; row++) {
//      for (int col = 0; col < 9; col++) {
//        // we search an empty cell
//        if (grid[row][col] == '') {
//          // we try possible numbers
//          for (int number = 1; number <= 9; number++) {
//            if (isOk(row, col, number.toString())) {
//              // number ok. it respects sudoku constraints
//              grid[row][col] = number.toString();
//
//              if (solve()) {
//                // we start backtracking recursively
//                return true;
//              } else {
//                // if not a solution, we empty the cell and we continue
//                grid[row][col] = '';
//              }
//            }
//          }
//
//          return false; // we return false
//        }
//      }
//    }
//    return true; // sudoku solved
//  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'weather',
      //     style: Theme.of(context).textTheme.headline1,
      //   ).tr(),
      //   centerTitle: false,
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //             return SearchByCityPage();
      //           }));
      //         },
      //         icon: Icon(CupertinoIcons.search)),
      //     IconButton(
      //         onPressed: () {
      //           Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //             return SettingPage();
      //           })).then((value) {
      //             if (value != null) {
      //               if (value) {
      //                 print('back unit ${context.read<TemperatureProvider>().unit}');
      //                 _bloc = WeatherBloc(
      //                     'lat=${position!.latitude.toString()}&lon=${position!.longitude.toString()}&exclude=minutely,hourly,daily&units=${context.read<TemperatureProvider>().unit}&appid=$APP_ID');
      //                 _bloc.getWeatherData();
      //                 _bloc.getWeatherStream().listen((event) {
      //                   if (event.responseState == ResponseState.loading) {}
      //                   if (event.responseState == ResponseState.data) {
      //                     _weatherOb = event.data;
      //                     print('${_weatherOb!.timezone.toString()}');
      //                     setState(() {});
      //                   }
      //                 });
      //               }
      //             }
      //           });
      //         },
      //         icon: Icon(CupertinoIcons.ellipsis_vertical))
      //   ],
      // ),
      body: _weatherOb == null || isLoading == true
          ? LoadingWidget()
          : Container(
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: context.read<SunriseProvider>().isSunrise ? AssetImage('assets/sunrise.jpeg') : AssetImage('assets/sunset.jpeg'), fit: BoxFit.fill)),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 40, 5, 20),
                    child: Row(
                      children: [
                        Text(
                          'weather',
                          style: Theme.of(context).textTheme.headline1,
                        ).tr(),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return SearchByCityPage();
                              }));
                            },
                            icon: Icon(
                              CupertinoIcons.search,
                              color: Colors.white,
                            )),
                        // IconButton(
                        //     onPressed: () {
                        //       Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        //         return SettingPage();
                        //       })).then((value) {
                        //         if (value != null) {
                        //           if (value) {
                        //             print('back unit ${context.read<TemperatureProvider>().unit}');
                        //             _bloc = WeatherBloc(
                        //                 'lat=${position!.latitude.toString()}&lon=${position!.longitude.toString()}&exclude=minutely,hourly,daily&units=${context.read<TemperatureProvider>().unit}&appid=$APP_ID');
                        //             _bloc.getWeatherData();
                        //             _bloc.getWeatherStream().listen((event) {
                        //               if (event.responseState == ResponseState.loading) {}
                        //               if (event.responseState == ResponseState.data) {
                        //                 _weatherOb = event.data;
                        //                 print('${_weatherOb!.timezone.toString()}');
                        //                 setState(() {});
                        //               }
                        //             });
                        //           }
                        //         }
                        //       });
                        //     },
                        //     icon: Icon(
                        //       CupertinoIcons.ellipsis_vertical,
                        //       color: Colors.white,
                        //     )),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
//                    print(position!.latitude.toString());
//                    print(position!.longitude.toString());

                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return WeatherDetailPage(
                          position!.latitude.toString(), //position!.latitude.toString(),
                          position!.longitude.toString(),
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
                                    Icon(
                                      CupertinoIcons.compass,
                                      color: Colors.blueGrey,
                                    ),
                                    Text(
                                      ' At your current location',
                                      style: Theme.of(context).textTheme.bodyText2,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${city ?? ''}',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                SizedBox(
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
                  SizedBox(
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
                                  context.setLocale(Locale('en'));
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
                                  context.setLocale(Locale('my'));
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
                                      'onecall?lat=${position!.latitude.toString()}&lon=${position!.longitude.toString()}&exclude=minutely,hourly,daily&units=${context.read<TemperatureProvider>().unit}&appid=$APP_ID');
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
                                      'onecall?lat=${position!.latitude.toString()}&lon=${position!.longitude.toString()}&exclude=minutely,hourly,daily&units=${context.read<TemperatureProvider>().unit}&appid=$APP_ID');
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
    // TODO: implement dispose
    super.dispose();
  }
}
