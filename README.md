# Introduction

`JSRuntime` provides a tool to build dart API to execute Javascript code.
`JSRuntime` provides mechanism to callback from javascript to dart.

Javascript code, for example related to a Study Definition logic, is wrapped in a `javascript namespace`.

Each `namespace` expose one `object` that is the `interface` used to communicate with `Dart`.

The `namespace object` is global and can be eventually used from other object(s) within other namespace(s).

`Namespace object` is created on demand. For example if we load a form the javascript logic related to that form is loaded in a namespace at the begin of the session and deleted at the end of the session.

Multiple namespaces can coexist in the same time.

Javascript can be executed in `mobile` or in the `web`. The interface exposed to `dart` must be agnostic of the environment where the javascript code is executed.

Javascript code is executed in a `JavaScript engine` in the mobile ([JavaScriptCore on iOS](https://developer.apple.com/documentation/javascriptcore) and in Android can be used either `JavaScriptCore` or [QuickJS](https://bellard.org/quickjs/).

In the web the Javascript code is executed in the browser and the code is injected when requested.

For the mobile has been used the [flutter_js plugin](https://pub.dev/packages/flutter_js)

For the web are used standard dart package `dart:html` and `dart:js` that permit interaction with the browser, the dom and provide interoperability between dart and javascript.

## JSRuntime

JSRuntime is a helper to permit abstraction of javascript communication between Dart and Javascript.

Call from Dart to a Javascript function can be synchronous and asynchronous means that from javascript function can be returned a promise.

From Javascript a callback to dart can be synchronous and return a possible value or can be asynchronous so from Dart can `resolve` or `reject` the call later.

When in the dart side there is callback defined then will be available in each `javascript namespace` specific own `sendToHost` function to send data to the dart side. It is up the specific implementation define the data structure sent: in the example is used map that is serialized before sent it to dart.

<img src="./images/js_runtime_design.png" style="display: block; margin-left: auto; margin-right: auto; width: 70%;"/>

## Example

Javascript code that we want to expose to dart:

```javascript
class Calculator {

  calculate(value1, value2) {
    return value1 + value2;
  }

}
```

The Dart interface will need to include the mixin `JSRegisterObject` and need to provide specific implementation for web and mobile. The code can be injected or provided using the mechanism as in this [example](https://bitbucket-signanthealth.valiantys.net/users/stefano.pironato_signanthealth.com/repos/js_runtime/browse/example/lib/proxy_handler):

```dart
abstract class Calculator with JSRegisterObject {
  @override
  final JSRuntime jsRuntime;

  Calculator(this.jsRuntime, CallbackFunction callback) {
    initialize(callback: callback);
  }

  factory ProxyHandler.withJSExecutor(
          JSRuntime jsRuntime, CallbackFunction callback) =>
      getCalculator(jsRuntime, callback);

  @override
  final String objectId = "calculator";

  @override
  final String source = <source code>;

  int calculate(int value1, int value2);
}
```

The we need the implementation fo the `Calculator` abstract class for `mobile` and `web`.

Mobile:
```dart
class CalculatorMobile extends Calculator {
  CalculatorMobile(JSRuntime jsRuntime, CallbackFunction callback)
      : super(jsRuntime, callback);

  @override
  int calculate(int value1, int value2) {
    final result =
        jsRuntime.callMethod(jsObject.id, "calculate", [value1, value2]);
    return result;
  }
}
```

Web:
```dart
class CalculatorWeb extends Calculator {
  late CalculatorJS calculatorJS;

  CalculatorWeb(JSRuntime jsRuntime, CallbackFunction callback)
      : super(jsRuntime, callback) {
    calculatorJS = jsObject.object as CalculatorJS;
  }

  @override
  int calculate(int value1, int value2) {
    return proxyHandlerJS.calculate(value1, value2);
  }
}

@JS()
class CalculatorJS {
  external calculate(int value1, int value2);
}
```


## Test

Test can be run for mobile and web
mobile:
``` shell
flutter test
```

web(Chrome);
``` shell
flutter test --platform chrome
```
