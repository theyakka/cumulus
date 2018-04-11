part of cumulus;

typedef void FunctionHandler(
    HandlerContext context,
    Parameters parameters,
    );

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
}
