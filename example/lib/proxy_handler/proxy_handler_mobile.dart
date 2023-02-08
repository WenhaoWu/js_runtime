import 'package:js_runtime/js_runtime.dart';

import 'proxy_handler.dart';

ProxyHandler getProxyHandler(JSRuntime jsRuntime, CallbackFunction callback) =>
    ProxyHandlerMobile(jsRuntime, callback);

class ProxyHandlerMobile extends ProxyHandler {
  ProxyHandlerMobile(JSRuntime jsRuntime, CallbackFunction callback)
      : super(jsRuntime, callback);

  @override
  int calculate(int value1, int value2) {
    final result =
        jsRuntime.callMethod(jsObject.id, "calculate", [value1, value2]);
    return result;
  }

  @override
  dynamic getValueFromHost(dynamic value) {
    return jsRuntime.callMethod(jsObject.id, "getValueFromHost", [value]);
  }
}
