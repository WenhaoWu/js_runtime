// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as dart_js;
// ignore: avoid_web_libraries_in_flutter
//import 'dart:js_util';
import 'package:flutter/foundation.dart';
import 'package:js_runtime/src/js_registerer.dart';
import 'package:js_runtime/src/js_registerer_web_callback.dart';
import 'package:js_runtime/src/js_runtime.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:js/js.dart' as js;
import 'package:collection/collection.dart' show IterableExtension;

JSRuntime getJSRuntime() => JSRuntimeWeb();

String _buildCallback(int? callbackIndex) => callbackIndex != null
    ? '''
    const callbackHost = function(value) {
      let result = callbackHost$callbackIndex(value instanceof Object ? JSON.stringify(value) : value);
      return result;
    }
'''
    : '';

String _buildWrapper(String id, String source, int? callbackIndex) => '''
  var $id = (function() {
    ${_buildCallback(callbackIndex)}
    $source
  })();
  objectRegistered($id);
''';

const consoleRedirect = '''
  class Console {
    log(...args) {
      callbackHost(JSON.stringify(['log', ...args]));
    }
    warn(...args) {
      callbackHost(JSON.stringify(['info', ...args]));
    }
    error(...args) {
      callbackHost(JSON.stringify(['error', ...args]));
    }
  }
  return new Console();
''';

const maxNumberCallbacks = 5;

class JSRuntimeWeb with JSRegisterer implements JSRuntime {
  dynamic lastRegisteredObject;
  late JSRuntimeObject consoleObject;

  final Map<int, String?> callbackSlots = {};

  @override
  void dispose() {
    disposeRegistered();
    consoleObject.dispose();
  }

  @override
  dynamic callMethod(
    String classVariableName,
    String method,
    List<dynamic> parameters,
  ) {
    throw UnimplementedError('callMethod');
  }

  @override
  Future<dynamic> callMethodAsync(
    String classVariableName,
    String method,
    List<dynamic> parameters,
  ) {
    throw UnimplementedError('callMethod');
  }

  void _objectRegistered(dynamic object) {
    lastRegisteredObject = object;
  }

  void callbackConsole(dynamic args) {
    try {
      var params = json.decode(args) as List;
      params.removeAt(0);
      final message = params.join(" ");
      // ignore: avoid_print
      print(message);
    } catch (_) {
      // ignore: avoid_print
      print(args.toString());
    }
  }

  @override
  void initialize() {
    debugPrint("WEB!!!!!");
    //initialize callback slots
    for (int index = 1; index <= maxNumberCallbacks; index++) {
      callbackSlots[index] = null;
    }
    setObjectRegistered = js.allowInterop(_objectRegistered);
    consoleObject = addObject(
        objectId: 'dartConsole',
        source: consoleRedirect,
        callback: callbackConsole);
  }

  _setCallback(int index, CallbackFunction callback) {
    switch (index) {
      case 1:
        setCallbackHost1 = js.allowInterop(callback);
        return;
      case 2:
        setCallbackHost2 = js.allowInterop(callback);
        return;
      case 3:
        setCallbackHost3 = js.allowInterop(callback);
        return;
      case 4:
        setCallbackHost4 = js.allowInterop(callback);
        return;
      case 5:
        setCallbackHost5 = js.allowInterop(callback);
        return;
    }
    throw "invalid callback index!!!";
  }

  int _addCallback(String objectId, CallbackFunction callback) {
    //search free callback slot
    final entry = callbackSlots.entries
        .firstWhereOrNull((element) => element.value == null);
    if (entry == null) {
      throw "Callback slot not available!!!";
    }
    _setCallback(entry.key, callback);
    callbackSlots[entry.key] = objectId;
    return entry.key;
  }

  @override
  JSRuntimeObject addObject({
    required String objectId,
    required String source,
    CallbackFunction? callback,
  }) {
    int? callbackIndex;

    if (callback != null) {
      callbackIndex = _addCallback(objectId, callback);
    }
    final body = html.window.document.getElementsByTagName('body');
    if (body.isNotEmpty) {
      final scriptElement = html.ScriptElement();
      scriptElement.id = objectId;
      scriptElement.text = _buildWrapper(objectId, source, callbackIndex);
      body[0].append(scriptElement);

      final result = JSRuntimeObjectWeb(
        objectId,
        lastRegisteredObject,
        scriptElement,
        this,
      );
      lastRegisteredObject = null;
      return result;
    } else {
      throw "Body not found!!!";
    }
  }
}

class JSRuntimeObjectWeb implements JSRuntimeObject {
  @override
  final String id;
  @override
  final dynamic object;

  final html.ScriptElement _scriptElement;
  final JSRuntimeWeb _jsRuntimeWeb;

  JSRuntimeObjectWeb(
    this.id,
    this.object,
    this._scriptElement,
    this._jsRuntimeWeb,
  );

  @override
  void dispose() {
    _scriptElement.remove();
    dart_js.context[id] = '';
    final entry = _jsRuntimeWeb.callbackSlots.entries
        .firstWhereOrNull((element) => element.value == id);
    if (entry != null) {
      _jsRuntimeWeb.callbackSlots[entry.key] = null;
    }
  }
}
