import 'package:js_runtime/js_runtime.dart';

import 'proxy_handler_provider.dart'
    if (dart.library.io) 'proxy_handler_mobile.dart'
    if (dart.library.js) 'proxy_handler_web.dart';

const proxyHandlerSource = """
    class ProxyHandler {

      constructor() {
        this.pages = new Map();
      }

      calculate(value1, value2) {
        return value1 + value2;
      }

      getValueFromHost(value) {
        console.log("value-->" + value);
        let callbackResult = callbackHost(value);
        return callbackResult;
      }
    }

    const proxyHandler = new ProxyHandler();
    return proxyHandler;
""";

abstract class ProxyHandler with JSRegisterObject {
  @override
  final JSRuntime jsRuntime;

  ProxyHandler(this.jsRuntime, CallbackFunction callback) {
    initialize(callback: callback);
  }

  factory ProxyHandler.withJSExecutor(
          JSRuntime jsRuntime, CallbackFunction callback) =>
      getProxyHandler(jsRuntime, callback);

  @override
  final String objectId = "proxyHandler";

  @override
  final String source = proxyHandlerSource;

  int calculate(int value1, int value2);

  dynamic getValueFromHost(dynamic value);
}
