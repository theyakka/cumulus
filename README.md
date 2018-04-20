
<img src="https://storage.googleapis.com/product-logos/logo_cumulus.png" align="center" width="160">

Cumulus is a high-level framework that makes developing application logic on top of Firebase quick and simple.

[![Build Status](https://travis-ci.org/theyakka/cumulus.svg?branch=master)](https://travis-ci.org/theyakka/cumulus)
[![Dart Version](https://img.shields.io/badge/Dart-2.0+-lightgrey.svg)](https://dartlang.org/)

# Features
Cumulus has the following bonza features:
- Simple, straightforward configuration of function endpoints
- Routable endpoints
- Common interface for routable and non-routable endpoints
- Named parameters for routable endpoints (e.g.: `/users/:id`)
- Querystring parameter parsing
- Build on the awesome [firebase-functions-interop](https://github.com/pulyaevskiy/firebase-functions-interop) library

# Installing

**Cumulus will probably require Dart 2.0+.** Cumulus was developed on the 2.0 (pre-release) version of Dart but, for now, it probably works fine on 1.X as well.

To install, add the following line to the `dependencies` section of your `pubspec.yaml` file:

```yaml
dependencies:
  ...
  cumulus: ^1.0.0

```

You can then import cumulus using:

```dart
import 'package:cumulus/cumulus.dart';
```

# Getting started

TBD - how to set up a project using dart

Next, we need to create an instance of a `CumulusApp` in the `main` function of your `index.dart` file. Something like:
```dart
void main() {
  CumulusApp app = new CumulusApp.appWithDefaults();
  app.addHandler("/welcome", handler: welcomeHandler);
}
```

Once this is done, you can define your handlers. For now we will add it to the `index.dart` file directly. Our handler looks like:
```dart
dynamic welcomeHandler(HandlerContext context, Parameters parameters) {
  final res = context.response;
  res.statusCode = 200;
  res.headers.contentType = ContentType.JSON;
  res.write(json.encode({
    "message": "HELLO!!!!",
  }));
  res.close();
  return null;  // we don't want to return any thing because it isn't routable and will be ignored
}
```

At this point you can run the build and then deploy your function.

# FAQ

## Why should I use this and not ____?

We prefer you use whatever you want. Cumulus is, most likely, no better or worse than the alternatives.

Cumulus was designed and developed because of an actual need to make working with Firebase Functions easier and faster. Developing apps should be fun, not tedious boilerplate and confusing templates. Hopefully Cumulus works for you personally.

Give it a try and if you like it, let us know! Either way, we love feedback.

## Has it been tested in production? Can I use it in production?

The code here is derived from the code that was written for Fluro (https://github.com/goposse/fluro). Fluro has been battle tested in the hamilton app in production and is used by millions of people. Cumulus is also in use serving Firebase Functions in other apps. That said, code is always evolving. We plan to keep on using it in production but we also plan to keep on improving it. If you find a bug, let us know!

## Who the f*ck is Yakka?

Yakka is the premier Flutter agency and a kick-ass product company. We focus on the work. Our stuff is at [http://theyakka.com](http://theyakka.com). Go check it out.

# Outro

## Credits

Without the [firebase-functions-interop](https://github.com/pulyaevskiy/firebase-functions-interop) library by [Anatoly Pulyaevskiy](https://github.com/pulyaevskiy) none of this would be possible. Go and star the project!

Cumulus is sponsored, owned and maintained by [Yakka LLC](http://theyakka.com). Feel free to reach out with suggestions, ideas or to say hey.

### Security

If you believe you have identified a serious security vulnerability or issue with Cumulus, please report it as soon as possible to apps@theyakka.com. Please refrain from posting it to the public issue tracker so that we have a chance to address it and notify everyone accordingly.

## License

Cumulus is released under a modified MIT license. See LICENSE for details.

<img src="https://storage.googleapis.com/yakka-logos/logo_wordmark.png" align="center" width="70">
