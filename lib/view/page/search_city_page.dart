import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/bloc/city_weather_bloc.dart';
import 'package:weather/bloc/weather_detail_bloc.dart';
import 'package:weather/model/city_weather_ob.dart';
import 'package:weather/model/response_ob.dart';
import 'package:weather/model/weather_detail_ob.dart';
import 'package:weather/provider/temperature_provider.dart';
import 'package:weather/utils/app_constants.dart';
import 'package:weather/view/widgets/loading_widget.dart';

import '../../provider/sunrise_provider.dart';

class SearchByCityPage extends StatefulWidget {
  @override
  _SearchByCityPageState createState() => _SearchByCityPageState();
}

class _SearchByCityPageState extends State<SearchByCityPage> {
  TextEditingController searchCityController = TextEditingController();

  late SearchCityWeatherBloc _bloc;
  late WeatherDetailBloc _weatherDetailBloc;

  SearchCityWeatherOb? _searchCityOb;
  WeatherDetailOb? _weatherDetailOb;

  bool isLoading = false;

  String? lat;
  String? lon;
  String? city;
  String? searchCity;

  List<String>? timeZone;
  List<String>? timeZoneCopy;

  goSearch(String str) {
    _bloc = SearchCityWeatherBloc('weather?q=$str&appid=$appId');
    setState(() {
      isLoading = true;
    });
    _bloc.getCityWeatherData();
    _bloc.getCityWeatherStream().listen((event) {
      if (event.responseState == ResponseState.noData) {
        setState(() {});
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No City Found!')));
      }
      if (event.responseState == ResponseState.data) {
        _searchCityOb = event.data;
        lat = _searchCityOb!.coord!.lat;
        lon = _searchCityOb!.coord!.lon;
        _weatherDetailBloc = WeatherDetailBloc('onecall?lat=${lat ?? ''}&lon=${lon ?? ''}&exclude=minutely&units=${context.read<TemperatureProvider>().unit}&appid=$appId');
        _weatherDetailBloc.getWeatherDetailData();
        _weatherDetailBloc.getWeatherStream().listen((event) {
          if (event.responseState == ResponseState.data) {
            _weatherDetailOb = event.data;
            isLoading = false;
            timeZone = _weatherDetailOb!.timezone!.split('/');
            city = timeZone![1].replaceAll('_', ' ');
            setState(() {});
            timeZoneCopy = List.from(timeZone!);
          } else {
            isLoading = false;
            setState(() {});
          }
        });
      }
      if (event.responseState == ResponseState.error) {
        setState(() {});
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unavailable!')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: context.read<SunriseProvider>().isSunrise ? const AssetImage('assets/sunrise.JPG') : const AssetImage('assets/sunset.JPG'), fit: BoxFit.fill)),
        child: CustomScrollView(
          // physics: const BouncingScrollPhysics(),
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
                expandedHeight: 170.0,
                floating: true,
                elevation: 0,
                title: Container(
                  decoration: BoxDecoration(color: Colors.grey.withOpacity(.2), borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    style: Theme.of(context).textTheme.bodyText1,
                    controller: searchCityController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            searchCityController.text.isNotEmpty ? goSearch(searchCityController.text) : null;
                            setState(() {});
                          },
                          icon: const Icon(CupertinoIcons.search)),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Search by City',
                      hintStyle: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Container(
                    color: _weatherDetailOb == null ? Colors.transparent : Colors.black54,
                  ),
                  title: _weatherDetailOb == null
                      ? Container()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              city == null ? '' : city!,
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(
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
                )),
            isLoading
                ? SliverToBoxAdapter(
                    child: LoadingWidget(),
                  )
                : SliverToBoxAdapter(
                    child: Container(),
                  ),
            isLoading || _weatherDetailOb == null
                ? const SliverPadding(
                    padding: EdgeInsets.all(10.0),
                  )
                : SliverToBoxAdapter(
                    child: _weatherDetailOb!.hourly == null || _weatherDetailOb!.hourly!.isEmpty
                        ? Container()
                        : Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                                        fadeInDuration: const Duration(seconds: 3),
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
            isLoading || _weatherDetailOb == null
                ? const SliverPadding(
                    padding: EdgeInsets.all(10.0),
                  )
                : SliverToBoxAdapter(
                    child: _weatherDetailOb!.daily == null || _weatherDetailOb!.daily!.isEmpty
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
                  ),
            isLoading || _weatherDetailOb == null
                ? const SliverPadding(
                    padding: EdgeInsets.all(10.0),
                  )
                : SliverToBoxAdapter(
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
                  ),
            const SliverPadding(
              padding: EdgeInsets.all(10.0),
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
    _weatherDetailBloc.dispose();
  }
}
