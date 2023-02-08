import 'js_runtime_provider.dart'
    if (dart.library.io) 'js_runtime_mobile.dart'
    if (dart.library.js) 'js_runtime_web.dart';

abstract class JSRuntimeObject {
  String get id;
  dynamic get object;
  void dispose();
}

typedef CallbackFunction = dynamic Function(dynamic);

abstract class JSRuntime {
  factory JSRuntime() => getJSRuntime();

  void initialize();

  void dispose();

  dynamic callMethod(
    String classVariableName,
    String method,
    List<dynamic> parameters,
  );

  Future<dynamic> callMethodAsync(
    String classVariableName,
    String method,
    List<dynamic> parameters,
  );

  /// {objectId} is used as variable where the source is wrapper as JS namespace
  /// {source} code that is added in JS namespace
  JSRuntimeObject registerObject({
    required String objectId,
    required String source,
    CallbackFunction? callback,
  });
}
