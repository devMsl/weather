import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/provider/temperature_provider.dart';
import 'package:weather/provider/theme_provider.dart';
import 'package:weather/utils/shared_pref.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int? selectedLang;
  String? selectedUnit;

  void checkLanguage() {
    SharedPref.getData(key: SharedPref.language).then((rv) {
      if (rv == "en") {
        setState(() {
          selectedLang = 1;
        });
      } else if (rv == "my") {
        setState(() {
          selectedLang = 2;
        });
      } else {
        setState(() {
          selectedLang = 1;
        });
      }
    });
  }

  void checkTempUnit() {
    SharedPref.getData(key: SharedPref.unit).then((rv) {
      if (rv == "metric") {
        setState(() {
          selectedUnit = 'metric';
        });
      } else if (rv == "imperial") {
        setState(() {
          selectedUnit = 'imperial';
        });
      } else {
        setState(() {
          selectedUnit = 'metric';
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLanguage();
    checkTempUnit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back_sharp),
      //     onPressed: () {
      //       Navigator.of(context).pop(true);
      //     },
      //   ),
      //   title: Text(
      //     'setting',
      //     style: Theme.of(context).textTheme.headline1,
      //   ).tr(),
      // ),
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/sunrise.jpeg'), fit: BoxFit.fill)),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 40, 5, 20),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_sharp),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                  Text(
                    'setting',
                    style: Theme.of(context).textTheme.headline1,
                  ).tr(),
                ],
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Language',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    RadioListTile(
                        title: Text(
                          'English',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        value: 1,
                        activeColor: Colors.cyan,
                        groupValue: selectedLang,
                        onChanged: (value) {
                          setState(() {
                            selectedLang = value as int;
                            SharedPref.setData(key: SharedPref.language, value: 'en');
                            context.setLocale(Locale('en'));
                          });
                        }),
                    RadioListTile(
                        title: Text(
                          'Myanmar',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        value: 2,
                        activeColor: Colors.cyan,
                        groupValue: selectedLang,
                        onChanged: (value) {
                          setState(() {
                            selectedLang = value as int;
                            SharedPref.setData(key: SharedPref.language, value: 'my');
                            context.setLocale(Locale('my'));
                          });
                        }),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Temperature Unit',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Consumer<TemperatureProvider>(builder: (context, TemperatureProvider temperatureProvider, child) {
                      return Column(
                        children: [
                          RadioListTile(
                              title: Text(
                                'Celsius',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              value: 'metric',
                              activeColor: Colors.cyan,
                              groupValue: selectedUnit,
                              onChanged: (value) {
                                setState(() {
                                  selectedUnit = value as String;
                                  SharedPref.setData(key: SharedPref.unit, value: 'metric');
                                  temperatureProvider.changeToCelsius();
                                });
                              }),
                          RadioListTile(
                              title: Text(
                                'Fahrenheit',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              value: 'imperial',
                              activeColor: Colors.cyan,
                              groupValue: selectedUnit,
                              onChanged: (value) {
                                setState(() {
                                  selectedUnit = value as String;
                                  SharedPref.setData(key: SharedPref.unit, value: 'imperial');
                                  temperatureProvider.changeToFahrenheit();
                                });
                              }),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Consumer<ThemeProvider>(
                      builder: (con, ThemeProvider tm, child) {
                        return ListTile(
                          title: Text(
                            'Theme Mode',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          leading: Icon(
                            Icons.palette,
                            color: Colors.cyan,
                          ),
                          trailing: DropdownButton(
                            items: [
                              DropdownMenuItem(
                                child: Text("Light"),
                                value: ThemeMode.light,
                              ),
                              DropdownMenuItem(child: Text("Dark"), value: ThemeMode.dark),
                              DropdownMenuItem(child: Text("System"), value: ThemeMode.system),
                            ],
                            onChanged: (value) {
                              if (value == ThemeMode.light) {
                                tm.changeToLight();
                              } else if (value == ThemeMode.dark) {
                                tm.changeToDark();
                              } else {
                                tm.changeToSystem();
                              }
                            },
                            value: tm.themeMode,
                            underline: Container(),
                          ),
                          // trailing: Switch(
                          //   value: tm.themeMode == ThemeMode.dark,
                          //   onChanged: (value) {
                          //     if (value) {
                          //       tm.changeToDark();
                          //     } else {
                          //       tm.changeToLight();
                          //     }
                          //   },
                          // ),
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
