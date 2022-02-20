import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:weather/model/city_weather_ob.dart';
import 'package:weather/model/respone_ob.dart';
import 'package:weather/utils/base_network.dart';

class SearchCityWeatherBloc extends BaseNetwork {
  String? endUrl;
  SearchCityWeatherBloc(this.endUrl);
  PublishSubject<ResponseOb> controller = PublishSubject();
  Stream<ResponseOb> getCityWeatherStream() => controller.stream;

  getCityWeatherData() {
    ResponseOb responseOb = ResponseOb(responseState: ResponseState.loading, data: null);
    controller.sink.add(responseOb);
    getRequest(url: endUrl ?? '').then((value) {
      Map<String, dynamic> map = json.decode(value.data);
      if (value.responseState == ResponseState.data) {
        SearchCityWeatherOb ob = SearchCityWeatherOb.fromJson(map);
        responseOb.responseState = ResponseState.data;
        responseOb.data = ob;
        controller.sink.add(responseOb);
      } else if (value.responseState == ResponseState.noData) {
        responseOb.responseState = ResponseState.noData;
        responseOb.data = map;
        controller.sink.add(responseOb);
      } else {
        responseOb.responseState = ResponseState.error;
        responseOb.data = value.data;
        controller.sink.add(responseOb);
      }
    }).catchError((err) {
      responseOb.responseState = ResponseState.error;
      responseOb.data = err.toString();
      controller.sink.add(responseOb);
    });
  }

  void dispose() {
    controller.close();
  }
}
