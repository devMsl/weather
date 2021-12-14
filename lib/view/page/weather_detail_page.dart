import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/bloc/weather_detail_bloc.dart';
import 'package:weather/model/respone_ob.dart';
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
//  List<String>? timeZoneCopy;

  String? city;
  bool isLoading = false;

  @override
  void initState() {
    _bloc = WeatherDetailBloc('onecall?lat=${widget.lat}&lon=${widget.lon}&exclude=minutely&units=${context.read<TemperatureProvider>().unit}&appid=$APP_ID');
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
//        timeZoneCopy = List.from(timeZone!);
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
          : Container(
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: context.read<SunriseProvider>().isSunrise ? AssetImage('assets/sunrise.jpeg') : AssetImage('assets/sunset.jpeg'), fit: BoxFit.fill)),
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back_sharp,
                          color: Theme.of(context).textTheme.headline3!.color,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      automaticallyImplyLeading: false,
                      expandedHeight: 210.0,
                      floating: false,
                      elevation: 0,
                      pinned: true,
//            stretch: false,
//            snap: true,
//            title: Text('kk'),
//            title: Column(
//              mainAxisAlignment: MainAxisAlignment.end,
//              children: [
//                Text(
//                  city!,
//                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20, fontWeight: FontWeight.normal),
//                ),
//                Text(
//                  timeZone![0],
//                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14, fontWeight: FontWeight.normal),
//                  textAlign: TextAlign.center,
//                ),
//              ],
//            ),
                      flexibleSpace: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          top = constraints.biggest.height;
                          return FlexibleSpaceBar(
                            background: Container(
                              color: Colors.black54, //Theme.of(context).cardColor,
                            ),
                            stretchModes: [StretchMode.zoomBackground],
                            title: _weatherDetailOb == null
                                ? Text(
                                    'loading',
                                    style: TextStyle(color: Colors.black),
                                  )
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        city == null ? '' : city!,
                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14, fontWeight: FontWeight.normal),
                                      ),
                                      _weatherDetailOb!.current!.weather![0].description == null
                                          ? Container()
                                          : Text(
                                              '${_weatherDetailOb!.current!.weather![0].description}',
                                              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 10, fontWeight: FontWeight.normal),
                                            ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      _weatherDetailOb!.current!.temp == 'null'
                                          ? Container()
                                          : Text(
                                              '${_weatherDetailOb!.current!.temp} ${context.watch<TemperatureProvider>().unit == 'metric' ? '\u2103' : '\u2109'}',
                                              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 23, fontWeight: FontWeight.normal),
                                            ),
                                    ],
                                  ),
                          );
                        },
                      )),
                  SliverToBoxAdapter(
                    child: _weatherDetailOb!.hourly == null || _weatherDetailOb!.hourly!.length == 0
                        ? Container()
                        : Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Card(
                              child: Container(
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
                                                        imageUrl: ICON_URL + _weatherDetailOb!.hourly![index].weather![0].icon! + TYPE_ICON,
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
                  ),
                  SliverToBoxAdapter(
                    child: _weatherDetailOb!.daily == null || _weatherDetailOb!.daily!.length == 0
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
                                                        imageUrl: ICON_URL + _weatherDetailOb!.daily![index].weather![0].icon! + TYPE_ICON,
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
                  ),
                  SliverToBoxAdapter(
                    child: Container(
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
                                            '${DateFormat('jm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(_weatherDetailOb!.current!.sunrise ?? '') * 1000, isUtc: true))}'),
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
                                            '${DateFormat('jm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(_weatherDetailOb!.current!.sunset ?? '') * 1000, isUtc: true))}'),
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
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(10.0),
                  )
                ],
              ),
            ),
    );
  }

  Widget todayInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
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
        SizedBox(
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