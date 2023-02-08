@JS()
library proxy_handler;

import 'package:js/js.dart';
import 'package:js_runtime/js_runtime.dart';
import 'test_js_class.dart';

TestJSClass getTestJSClass(JSRuntime jsRuntime, CallbackFunction callback) =>
    TestJSClassWeb(jsRuntime, callback);

class TestJSClassWeb extends TestJSClass {
  late TestJSClassJS testJSClassJS;

  TestJSClassWeb(JSRuntime jsRuntime, CallbackFunction callback)
      : super(jsRuntime, callback) {
    testJSClassJS = jsObject.object as TestJSClassJS;
  }

  @override
  num calculate(num value1, num value2, [num? value3]) {
    return testJSClassJS.calculate(value1, value2, value3);
  }

  @override
  dynamic concatenate(dynamic str1, dynamic str2, [dynamic str3]) {
    return testJSClassJS.concatenate(str1, str2, str3);
  }

  @override
  List<dynamic> concatValues(dynamic value1, dynamic value2, dynamic value3) {
    return testJSClassJS.concatValues(value1, value2, value3);
  }

  @override
  dynamic getValueFromHost(dynamic value) {
    return testJSClassJS.getValueFromHost(value);
  }
}

@JS()
class TestJSClassJS {
  external num calculate(num value1, num value2, [num? value3]);
  external dynamic concatenate(dynamic str1, dynamic str2, [dynamic str3]);
  external List<dynamic> concatValues(
      dynamic value1, dynamic value2, dynamic value3);
  external dynamic getValueFromHost(dynamic value);
}
