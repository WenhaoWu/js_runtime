import 'package:flutter/foundation.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:js_runtime/src/js_registerer.dart';
import 'package:js_runtime/src/js_runtime.dart';

JSRuntime getJSRuntime() => JSRuntimeMobile();

String _buildCallback(String id, bool hasCallback) => hasCallback
    ? '''
    const callbackHost = function(value) {
      let result = sendMessage('callback$id', JSON.stringify(value));
      return result;
    }
'''
    : '';

const dartConsole = '''
  class Console {
    log(...args) {
      console.log(...args);
    }
    warn(...args) {
      console.log(...args);
    }
    error(...args) {
      console.log(...args);
    }
  }
  const dartConsole = new Console();
''';

String _buildWrapper(String id, String source, bool hasCallback) => '''
  var $id = (function() {
    $dartConsole

    ${_buildCallback(id, hasCallback)}

    $source

  })();
''';

class JSRuntimeMobile with JSRegisterer implements JSRuntime {
  // Javascript engine on mobile
  late JavascriptRuntime javascriptRuntime;

  @override
  void dispose() {
    disposeRegistered();
    javascriptRuntime.dispose();
  }

  @override
  void initialize() {
    debugPrint("MOBILE!!!!!");
    javascriptRuntime = getJavascriptRuntime(
      xhr: false,
      forceJavascriptCoreOnAndroid: true,
    );
  }

  @override
  JSRuntimeObject addObject({
    required String objectId,
    required String source,
    CallbackFunction? callback,
  }) {
    if (callback != null) {
      javascriptRuntime.onMessage('callback$objectId', callback);
    }
    final code = _buildWrapper(objectId, source, callback != null);
    final res = javascriptRuntime.evaluate(code);
    if (res.isError) {
      throw "error in loading code: ${res.stringResult}";
    }
    return JSRuntimeObjectMobile(objectId, res.rawResult, javascriptRuntime);
  }

  @override
  dynamic callMethod(
    String classVariableName,
    String method,
    List<dynamic> parameters,
  ) {
    final code = buildMethodCall(classVariableName, method, parameters);
    final result = javascriptRuntime.evaluate(code);
    if (result.isError) {
      throw "Error ${result.stringResult}";
    }
    //return result.rawResult;
    return javascriptRuntime.convertValue(result);
  }

  @override
  Future<dynamic> callMethodAsync(
    String classVariableName,
    String method,
    List<dynamic> parameters,
  ) async {
    final code = buildMethodCall(classVariableName, method, parameters);
    final result = await _evaluate(code);
    return result;
  }

  Future<dynamic> _evaluate(String code) async {
    final result = javascriptRuntime.evaluate(code);
    if (result.isPromise || result.rawResult is Future) {
      final promiseResolved = await javascriptRuntime.handlePromise(result);
      return promiseResolved.stringResult;
    }
    if (result.isError) {
      return Future.error(result);
    }
    return javascriptRuntime.convertValue(result); //result.rawResult;
  }

  String buildMethodCall(
      String classVariableName, String method, List<dynamic> parameters) {
    final parametersString = parameters.map(convertValueToJS).join(',');
    return '$classVariableName.$method($parametersString)';
  }
}

String convertValueToJS(value) {
  if (value == null) {
    return "null";
  }
  if (value is String) {
    return "'$value'";
  }
  if (value is bool) {
    return value ? "true" : "false";
  }
  if (value is List) {
    return "[${value.map(convertValueToJS).join(',')}]";
  }
  return value.toString();
}

class JSRuntimeObjectMobile implements JSRuntimeObject {
  @override
  final String id;
  @override
  final dynamic object;

  final JavascriptRuntime _runtime;

  JSRuntimeObjectMobile(this.id, this.object, this._runtime);

  @override
  void dispose() {
    _runtime.evaluate("$id = null");
  }
}
