import 'package:js_runtime/js_runtime.dart';

import 'test_js_class_provider.dart'
    if (dart.library.io) 'test_js_class_mobile.dart'
    if (dart.library.js) 'test_js_class_web.dart';

const testJSClassSource = """


    class TestJSClass {

      constructor() {
        this.pages = new Map();
      }

      calculate(value1, value2, value3) {
        return value1 + value2 + value3;
      }

      sumIdArray(value) {
        if (value) {
          if (Array.isArray(value)) {
            return value.reduce((partial,v) => partial+v,null);
          }
        }
        return value;
      }

      concatenate(value1, value2, value3 = null) {
        return this.sumIdArray(value1) + this.sumIdArray(value2) + this.sumIdArray(value3);
      }

      concatValues(value1, value2, value3) {
        let result = [];
        return result.concat(value1,value2, value3);
      }

      getValueFromHost(value) {
        console.log("value-->" + value);
        let callbackResult = callbackHost(value);
        return callbackResult;
      }
    }

    const testJSClass = new TestJSClass();
    return testJSClass;
""";

abstract class TestJSClass with JSRegisterObject {
  @override
  final JSRuntime jsRuntime;

  TestJSClass(this.jsRuntime, CallbackFunction callback) {
    initialize(callback: callback);
  }

  factory TestJSClass.withJSRuntime(
          JSRuntime jsRuntime, CallbackFunction callback) =>
      getTestJSClass(jsRuntime, callback);

  @override
  final String objectId = "testJSClass";

  @override
  final String source = testJSClassSource;

  num calculate(num value1, num value2, [num? value3]);

  dynamic concatenate(dynamic value1, dynamic value2, [dynamic value3]);

  List<dynamic> concatValues(dynamic value1, dynamic value2, dynamic value3);

  dynamic getValueFromHost(dynamic value);
}
