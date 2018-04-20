part of cumulus;

typedef void HandlerResponseBlock(HttpResponse response);

class HandlerContext {
  final CumulusApp app;
  final ExpressHttpRequest request;
  final HttpResponse response;
  final dynamic data;
  HandlerContext({
    @required this.app,
    @required this.request,
    @required this.response,
    dynamic this.data,
  });

  bool get isJsonRequest =>
      request.headers.contentType.mimeType.startsWith("application/json");

  bool get isFormRequest => request.headers.contentType.mimeType
      .startsWith("application/x-www-form-urlencoded");

  Parameters get parameters {
    Parameters parameters = new Parameters();
    parameters.addMap(request.uri.queryParametersAll);
    if (isJsonRequest || isFormRequest) {
      Map<String, dynamic> map = request.body;
      map.forEach((key, val) {
        parameters.add(key, val);
      });
    }
    return parameters;
  }

  HttpResponse jsonResponse({
    @required Object value,
    HandlerResponseBlock responseProcessor,
    int statusCode = HttpStatus.OK,
    dynamic returnValue = null,
  }) {
    final res = this.response;
    res.statusCode = statusCode;
    res.headers.contentType = ContentType.JSON;
    if (responseProcessor != null) {
      responseProcessor(res);
    }
    if (value is String) {
      res.write(value);
    } else {
      res.write(json.encode(value));
    }
    res.close();
    return res;
  }
}
