import 'package:js_runtime/src/js_runtime.dart';

abstract class JSRegisterer {
  final List<JSRuntimeObject> _runtimeObjects = [];

  JSRuntimeObject addObject({
    required String objectId,
    required String source,
    CallbackFunction? callback,
  });

  JSRuntimeObject registerObject({
    required String objectId,
    required String source,
    CallbackFunction? callback,
  }) {
    final result = addObject(
      objectId: objectId,
      source: source,
      callback: callback,
    );
    _runtimeObjects.add(result);
    return result;
  }

  void disposeRegistered() {
    for (final object in _runtimeObjects) {
      object.dispose();
    }
    _runtimeObjects.clear();
  }
}
