@JS()
library proxy_handler;

import 'package:js/js.dart';
import 'package:js_runtime/js_runtime.dart';
import 'proxy_handler.dart';

ProxyHandler getProxyHandler(JSRuntime jsRuntime, CallbackFunction callback) =>
    ProxyHandlerWeb(jsRuntime, callback);

class ProxyHandlerWeb extends ProxyHandler {
  late ProxyHandlerJS proxyHandlerJS;

  ProxyHandlerWeb(JSRuntime jsRuntime, CallbackFunction callback)
      : super(jsRuntime, callback) {
    proxyHandlerJS = jsObject.object as ProxyHandlerJS;
  }

  @override
  int calculate(int value1, int value2) {
    return proxyHandlerJS.calculate(value1, value2);
  }

  @override
  dynamic getValueFromHost(dynamic value) {
    return proxyHandlerJS.getValueFromHost(value);
  }
}

@JS()
class ProxyHandlerJS {
  external calculate(int value1, int value2);
  external dynamic getValueFromHost(dynamic value);
}
