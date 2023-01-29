import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/bloc/weather_detail_bloc.dart';
import 'package:weather/model/response_ob.dart';
import 'package:weather/model/weather_detail_ob.dart';
import 'package:weather/provider/sunrise_provider.dart';
import 'package:weather/provider/temperature_provider.dart';
import 'package:weather/utils/app_constants.dart';
import 'package:weather/view/widgets/loading_widget.dart';

class WeatherDetailPage extends StatefulWidget {
  String? lat;
  String? lon;
  WeatherDetailPage(this.lat, this.lon);
  @override
  _WeatherDetailPageState createState() => _WeatherDetailPageState();
}

class _WeatherDetailPageState extends State<WeatherDetailPage> {
  late WeatherDetailBloc _bloc;
  WeatherDetailOb? _weatherDetailOb;
  List<String>? timeZone;

  String? city;
  bool isLoading = false;

  @override
  void initState() {
    _bloc = WeatherDetailBloc('onecall?lat=${widget.lat}&lon=${widget.lon}&exclude=minutely&units=${context.read<TemperatureProvider>().unit}&appid=$appId');
    _bloc.getWeatherDetailData();
    _bloc.getWeatherStream().listen((event) {
      if (event.responseState == ResponseState.loading) {
        isLoading = true;
        setState(() {});
      }
      if (event.responseState == ResponseState.data) {
        _weatherDetailOb = event.data;
        isLoading = false;
        timeZone = _weatherDetailOb!.timezone!.split('/');
        city = timeZone![1].replaceAll('_', ' ');
        setState(() {});
      }
    });
    super.initState();
  }

  var top = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading || _weatherDetailOb == null
          ? LoadingWidget()
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 40, 5, 20),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: context.read<SunriseProvider>().isSunrise ? const AssetImage('assets/sunrise.JPG') : const AssetImage('assets/sunset.JPG'), fit: BoxFit.fill)),
                child: Column(
                  children: [
                    _weatherDetailOb == null
                        ? const Text(
                            'loading',
                            style: TextStyle(color: Colors.black),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        city == null ? '' : city!,
                                        style: Theme.of(context).textTheme.headline2,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      _weatherDetailOb!.current!.temp == 'null'
                                          ? Container()
                                          : Text(
                                              '${_weatherDetailOb!.current!.temp} ${context.watch<TemperatureProvider>().unit == 'metric' ? '\u2103' : '\u2109'}',
                                              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 23, fontWeight: FontWeight.normal),
                                            ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        icon: const Icon(
                                          Icons.home,
                                          color: Colors.white,
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                    _weatherDetailOb!.hourly == null || _weatherDetailOb!.hourly!.isEmpty
                        ? Container()
                        : Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                            child: Card(
                              child: SizedBox(
                                height: 130,
                                child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _weatherDetailOb!.hourly!.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                _weatherDetailOb!.hourly![index].dt == 'null'
                                                    ? Container()
                                                    : Text(
                                                        DateFormat('j')
                                                            .format(DateTime.fromMillisecondsSinceEpoch(int.parse(_weatherDetailOb!.hourly![index].dt!) * 1000, isUtc: true)),
                                                        style: Theme.of(context).textTheme.bodyText2,
                                                      ),
                                                _weatherDetailOb!.hourly![index].weather![0].icon == null
                                                    ? Container()
                                                    : CachedNetworkImage(
                                                        imageUrl: iconUrl + _weatherDetailOb!.hourly![index].weather![0].icon! + typeIcon,
                                                        height: 50,
                                                        width: 50,
                                                        fadeInCurve: Curves.bounceIn,
                                                        fadeInDuration: Duration(seconds: 3),
                                                      ),
                                                _weatherDetailOb!.hourly![index].temp == 'null'
                                                    ? Container()
                                                    : Text(
                                                        '${_weatherDetailOb!.hourly![index].temp ?? ''} ${context.watch<TemperatureProvider>().unit == 'metric' ? '\u2103' : '\u2109'}',
                                                        style: Theme.of(context).textTheme.bodyText1,
                                                      ),
                                              ],
                                            ),
                                          );
                                        })),
                              ),
                            ),
                          ),
                    _weatherDetailOb!.daily == null || _weatherDetailOb!.daily!.isEmpty
                        ? Container()
                        : Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(_weatherDetailOb!.daily!.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                _weatherDetailOb!.daily![index].dt == 'null'
                                                    ? Container()
                                                    : Text(
                                                        DateFormat('EEEE')
                                                            .format(DateTime.fromMillisecondsSinceEpoch(int.parse(_weatherDetailOb!.daily![index].dt!) * 1000, isUtc: true)),
                                                        style: Theme.of(context).textTheme.bodyText2,
                                                      ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                _weatherDetailOb!.daily![index].weather![0].icon == 'null'
                                                    ? Container()
                                                    : CachedNetworkImage(
                                                        imageUrl: iconUrl + _weatherDetailOb!.daily![index].weather![0].icon! + typeIcon,
                                                        height: 30,
                                                        width: 50,
                                                      )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                _weatherDetailOb!.daily![index].temp!.max == 'null'
                                                    ? Container()
                                                    : Text(
                                                        '${_weatherDetailOb!.daily![index].temp!.max ?? ''} \u00B0',
                                                        style: Theme.of(context).textTheme.bodyText1,
                                                      )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                _weatherDetailOb!.daily![index].temp!.min == 'null'
                                                    ? Container()
                                                    : Text(
                                                        '${_weatherDetailOb!.daily![index].temp!.min ?? ''} \u00B0',
                                                        style: Theme.of(context).textTheme.bodyText1,
                                                      )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _weatherDetailOb!.current!.sunrise == 'null'
                                        ? Container()
                                        : todayInfo('Sunrise',
                                            DateFormat('jm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(_weatherDetailOb!.current!.sunrise ?? '') * 1000, isUtc: true))),
                                    _weatherDetailOb!.current!.clouds == 'null' ? Container() : todayInfo('Cloudiness', '${_weatherDetailOb!.current!.clouds} %'),
                                    _weatherDetailOb!.current!.windSpeed == 'null'
                                        ? Container()
                                        : todayInfo('Wind', '${_weatherDetailOb!.current!.windSpeed} ${context.watch<TemperatureProvider>().unit == 'metric' ? 'm/s' : 'Mph'}'),
                                    _weatherDetailOb!.current!.rain.toString() == 'null'
                                        ? Container()
                                        : todayInfo('Precipitation', '${_weatherDetailOb!.current!.rain!.d1h == 'null' ? '' : _weatherDetailOb!.current!.rain!.d1h} mm'),
                                    _weatherDetailOb!.current!.visibility == 'null' ? Container() : todayInfo('Visibility', '${_weatherDetailOb!.current!.visibility} m'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _weatherDetailOb!.current!.sunrise == 'null'
                                        ? Container()
                                        : todayInfo('Sunset',
                                            DateFormat('jm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(_weatherDetailOb!.current!.sunset ?? '') * 1000, isUtc: true))),
                                    _weatherDetailOb!.current!.humidity == 'null' ? Container() : todayInfo('Humidity', '${_weatherDetailOb!.current!.humidity} %'),
                                    _weatherDetailOb!.current!.feelsLike == 'null' ? Container() : todayInfo('Feels Like', '${_weatherDetailOb!.current!.feelsLike} \u00B0'),
                                    _weatherDetailOb!.current!.pressure == 'null' ? Container() : todayInfo('Pressure', '${_weatherDetailOb!.current!.pressure} hPa'),
                                    _weatherDetailOb!.current!.uvi == 'null' ? Container() : todayInfo('UV Index', '${_weatherDetailOb!.current!.uvi} '),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget todayInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 18, fontWeight: FontWeight.normal),
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bloc.dispose();
  }
}
