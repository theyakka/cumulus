part of cumulus;

/// This is where all the main application logic and routing is configured.
class CumulusApp {
  static CumulusApp _instance;
  final App firebase;
  Router _router;

  CumulusApp(this.firebase);
  CumulusApp.appWithDefaults() : this.firebase = _configureDefaultApp();

  /// Configure the static instance (accessed by [CumulusApp.instance].
  static CumulusApp configure(App firebase) {
    return _instance ??= new CumulusApp(firebase);
  }

  /// Retrieve the static instance. If not configured the static instance will
  /// use the firebase library defaults.
  static CumulusApp get instance =>
      _instance ??= new CumulusApp(_configureDefaultApp());
  static App _configureDefaultApp() {
    return FirebaseAdmin.instance.initializeApp(
      FirebaseFunctions.config.firebase,
    );
  }

  /// Adds a function handler. A function handler does not support nested paths
  /// or named parameters. It is a direct connection to the firebase functions
  /// library. You should use this type of handler if you don't need any kind
  /// of advanced routing capabilities.
  void addHandler(String function, {@required FunctionHandler handler}) {
    var functionName = function;
    if (function.startsWith("/")) {
      functionName = functionName.substring(1);
    }
    functions[functionName] = FirebaseFunctions.https
        .onRequest((request) => _directHandler(request, handler));
  }

  ///
  void addRouteHandler(String path, {@required FunctionHandler handler}) {
    if (_router == null) {
      addRouter(_defaultRouter());
    }
    _router.addRoute(
        new RouteDefinition.withCallback(path, callback: (params, context) {
      handler(context, params);
    }));
  }

  ///
  void addRouter(Router router, {String functionName = "r"}) {
    _router = router;
    functions[functionName] = FirebaseFunctions.https.onRequest(_routerHandler);
  }

  Router _defaultRouter() {
    return new Router(
      noMatchHandler: new Handler(callback: _noMatchHandler),
    );
  }

  ///
  _directHandler(ExpressHttpRequest request, FunctionHandler handler) {
    final context = HandlerContext(
      app: this,
      request: request,
      response: request.response,
    );
    handler(context, null);
  }

  ///
  dynamic _routerHandler(ExpressHttpRequest request) {
    final path = request.uri.toString();
    final context = HandlerContext(
      app: this,
      request: request,
      response: request.response,
    );
    dynamic result;
    MatchResult match = _router.match(path, context: context);
    if (match.wasMatched) {
      result = match.route.handler.callback(
        match.parameters,
        match.context,
      );
    } else {
      if (_router.noMatchHandler != null) {
        result = _router.noMatchHandler.callback(
          match.parameters,
          match.context,
        );
      } else {
        result = _noMatchHandler(
          match.parameters,
          match.context,
        );
      }
    }
    return result;
  }

  /// The default no match handler. Just returns a simple text string.
  dynamic _noMatchHandler(Parameters parameters, dynamic context) {
    HandlerContext handlerContext = context;
    HttpResponse response = handlerContext.response;
    response.statusCode = HttpStatus.NOT_FOUND;
    response.headers.contentType = ContentType.TEXT;
    response.writeln("404: Not found");
    response.close();
    return null;
  }
}
