class ResponseOb {
  dynamic data;
  ResponseState? responseState;
  ResponseOb({this.data, this.responseState});
}

enum ResponseState { loading, data, error, noData }
