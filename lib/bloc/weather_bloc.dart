import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:weather/model/respone_ob.dart';
import 'package:weather/model/weather_ob.dart';
import 'package:weather/utils/base_network.dart';

class WeatherBloc extends BaseNetwork {
  String? endUrl;
  WeatherBloc(this.endUrl);
  PublishSubject<ResponseOb> controller = PublishSubject();
  Stream<ResponseOb> getWeatherStream() => controller.stream;

  getWeatherData() {
    ResponseOb resp = ResponseOb(responseState: ResponseState.loading, data: null);
    controller.sink.add(resp);
    getRequest(url: endUrl ?? '').then((rv) {
      Map<String, dynamic> map = json.decode(rv.data);
      if (rv.responseState == ResponseState.data) {
//        if (map != null) {
        //        T ob = T.fromJson(map);
        WeatherOb ob = WeatherOb.fromJson(map);
        resp.responseState = ResponseState.data;
        resp.data = ob;
        controller.sink.add(resp);
//        }

//        if (rv.data is WeatherOb) {
//          print('weatherob');
//        }
//        if (rv.data is WeatherDetailOb) {
//          print('weather deatil ob');
//        }
      } else {
        resp.responseState = ResponseState.error;
        resp.data = rv.data;
        controller.sink.add(resp);
      }
    }).catchError((err) {
      resp.responseState = ResponseState.error;
      resp.data = err.toString();
      controller.sink.add(resp);
    });
  }

  void dispose() {
    controller.close();
  }
}
