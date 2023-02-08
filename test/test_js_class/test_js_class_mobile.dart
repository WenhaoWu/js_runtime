import 'package:js_runtime/js_runtime.dart';

import 'test_js_class.dart';

TestJSClass getTestJSClass(JSRuntime jsRuntime, CallbackFunction callback) =>
    TestJSClassMobile(jsRuntime, callback);

class TestJSClassMobile extends TestJSClass {
  TestJSClassMobile(JSRuntime jsRuntime, CallbackFunction callback)
      : super(jsRuntime, callback);

  @override
  num calculate(num value1, num value2, [num? value3]) {
    return jsRuntime
        .callMethod(jsObject.id, "calculate", [value1, value2, value3]);
  }

  @override
  dynamic concatenate(dynamic str1, dynamic str2, [dynamic str3]) {
    return jsRuntime.callMethod(jsObject.id, "concatenate", [str1, str2, str3]);
  }

  @override
  List<dynamic> concatValues(dynamic value1, dynamic value2, dynamic value3) {
    return jsRuntime
        .callMethod(jsObject.id, "concatValues", [value1, value2, value3]);
  }

  @override
  dynamic getValueFromHost(dynamic value) {
    return jsRuntime.callMethod(jsObject.id, "getValueFromHost", [value]);
  }
}
