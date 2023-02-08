@JS()
library js_helper;

import 'package:js/js.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';

@JS('Object.keys')
external List<String> getKeysOfObject(jsObject);

Map jsToMap(jsObject) {
  return Map.fromIterable(
    getKeysOfObject(jsObject),
    value: (key) => getProperty(jsObject, key),
  );
}

Map<K, V> mapFromJS<K, V>(Map<K, V>? jsObject) {
  if (jsObject == null) {
    return {};
  }
  final keys = getKeysOfObject(jsObject);
  return Map.fromIterable(keys, value: (key) {
    return getProperty(jsObject, key);
  });
}
