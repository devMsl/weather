import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:weather/model/respone_ob.dart';
import 'package:weather/utils/app_constants.dart';

class BaseNetwork {
  Future<ResponseOb> getRequest({required String url}) async {
    ResponseOb rv = ResponseOb();
    return await http.get(Uri.parse(BASE_URL + url)).then((res) {
      print(res.statusCode);
      if (res.statusCode == 200) {
        rv.responseState = ResponseState.data;
        rv.data = res.body;
      } else if (res.statusCode == 404) {
        rv.responseState = ResponseState.noData;
        rv.data = res.body; //'City not found!';
      } else if (res.statusCode == 429) {
        rv.responseState = ResponseState.error;
        rv.data = 'Too many requests!';
      } else {
        rv.responseState = ResponseState.error;
        rv.data = "Data Fetching Error";
      }
      return rv;
    }).catchError((e) {
      if (e is SocketException) {
        rv.responseState = ResponseState.error;
        rv.data = "No Internet";
      } else {
        rv.responseState = ResponseState.error;
        rv.data = "Data ${e.toString()} Error";
      }
      return rv;
    });
  }
}
