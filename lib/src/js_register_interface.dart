import 'package:js_runtime/src/js_runtime.dart';

abstract class JSRegisterObject {
  JSRuntime get jsRuntime;
  String get objectId;
  String get source;

  late JSRuntimeObject jsObject;

  initialize({CallbackFunction? callback}) {
    jsObject = jsRuntime.registerObject(
      objectId: objectId,
      source: source,
      callback: callback,
    );
  }

  void dispose() {
    jsObject.dispose();
  }
}
