import 'package:flutter_test/flutter_test.dart';

import 'package:js_runtime/js_runtime.dart';

import 'test_js_class/test_js_class.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'js_runtime_test.mocks.dart';

abstract class Callback {
  dynamic callback(dynamic);
}

@GenerateMocks([
  Callback,
])
void main() {
  late JSRuntime jsRuntime;
  late TestJSClass testJSClass;
  late MockCallback mockCallback;

  setUp(() {
    jsRuntime = JSRuntime();
    jsRuntime.initialize();
    mockCallback = MockCallback();
    testJSClass = TestJSClass.withJSRuntime(jsRuntime, mockCallback.callback);
  });

  tearDown(() {
    testJSClass.dispose();
    jsRuntime.dispose();
  });

  group('test on mac', () {
    test('calculate all values int', () async {
      final value = testJSClass.calculate(4, 5, 6);
      expect(value, isA<int>());
      expect(value, 15);
    });

    test('calculate with null int', () async {
      final value = testJSClass.calculate(4, 5);
      expect(value, isA<int>());
      expect(value, 9);
    });

    test('calculate with double int', () async {
      final value = testJSClass.calculate(4.5, 5.6, 6.7);
      expect(value, isA<double>());
      expect(value, 16.8);
    });

    test('concatenate strings', () async {
      final value = testJSClass.concatenate("str1", "str2", "str3");
      expect(value, isA<String>());
      expect(value, "str1str2str3");
    });
    test('concatenate strings with null', () async {
      final value = testJSClass.concatenate("str1", "str2");
      expect(value, isA<String>());
      expect(value, "str1str2null");
    });
    test('concatenate strings with bool', () async {
      final value = testJSClass.concatenate("str1", "str2", true);
      expect(value, isA<String>());
      expect(value, "str1str2true");
    });
    test('concatenate with bool return int', () async {
      final value = testJSClass.concatenate(true, false, true);
      expect(value, isA<int>());
      expect(value, 2);
    });
    test('concatenate with null return int', () async {
      final value = testJSClass.concatenate(null, 4, 5);
      expect(value, isA<int>());
      expect(value, 9);
    });
    test('concatenate return double', () async {
      final value = testJSClass.concatenate(1.2, 1, 2);
      expect(value, isA<double>());
      expect(value, 4.2);
    });
    test('concatenate return int with list', () async {
      final value = testJSClass.concatenate([1, 1], [2, 2], [3, 3]);
      expect(value, isA<int>());
      expect(value, 12);
    });
    test('concatenate return int with list and null', () async {
      final value = testJSClass.concatenate([1, 1], [2, 2]);
      expect(value, isA<int>());
      expect(value, 6);
    });
    test('concatenate return int with list and bool', () async {
      final value =
          testJSClass.concatenate([1, 1], [2, 2], [false, false, true]);
      expect(value, isA<int>());
      expect(value, 7);
    });
    test('concatenate with list of strings', () async {
      final value = testJSClass.concatenate("str1", ["str2", "str3"], "str4");
      expect(value, isA<String>());
      expect(value, "str1nullstr2str3str4");
    });

    test('concatValues with all array', () async {
      final value = testJSClass.concatValues([1, 2], [3, 4, 5], [6, 7, 8, 9]);
      expect(value, isA<List>());
      expect(value, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });

    test('concatValues with single value', () async {
      final value = testJSClass.concatValues(1, 2, 3);
      expect(value, isA<List>());
      expect(value, [1, 2, 3]);
    });

    test('concatValues with all array different types', () async {
      final value = testJSClass.concatValues(
          ["1", 2], [3, "4", 5.5, true], [6.7, 7.8, "8.8", 9, false]);
      expect(value, isA<List>());
      expect(value, ["1", 2, 3, "4", 5.5, true, 6.7, 7.8, "8.8", 9, false]);
    });

    test('getValueFromHost with int', () async {
      when(mockCallback.callback(5)).thenReturn(10);
      final value = testJSClass.getValueFromHost(5);
      expect(value, isA<int>());
      expect(value, 10);
    });

    test('getValueFromHost with double', () async {
      when(mockCallback.callback(1.1)).thenReturn(12.345);
      final value = testJSClass.getValueFromHost(1.1);
      expect(value, isA<double>());
      expect(value, 12.345);
    });

    test('getValueFromHost with bool true', () async {
      when(mockCallback.callback(false)).thenReturn(true);
      final value = testJSClass.getValueFromHost(false);
      expect(value, isA<bool>());
      expect(value, true);
    });

    test('getValueFromHost with bool false', () async {
      when(mockCallback.callback(true)).thenReturn(false);
      final value = testJSClass.getValueFromHost(true);
      expect(value, isA<bool>());
      expect(value, false);
    });

    test('getValueFromHost with return string', () async {
      when(mockCallback.callback(1)).thenReturn('test result as string');
      final value = testJSClass.getValueFromHost(1);
      expect(value, isA<String>());
      expect(value, 'test result as string');
    });

    // TODO: for some unknown reason passing a parameter to the sendMessage raise a exception
    // test('getValueFromHost with par string and return string', () async {
    //   when(mockCallback.callback('test')).thenReturn('test result as string');
    //   final value = testJSClass.getValueFromHost('test');
    //   expect(value, isA<String>());
    //   expect(value, 'test result as string');
    // });

    test('getValueFromHost with null', () async {
      when(mockCallback.callback(null)).thenReturn(10);
      final value = testJSClass.getValueFromHost(null);
      expect(value, isA<int>());
      expect(value, 10);
    });

    test('getValueFromHost with null return null', () async {
      when(mockCallback.callback(null)).thenReturn(null);
      final value = testJSClass.getValueFromHost(null);
      expect(value, isNull);
    });
  });

  // test('return variable value int', () async {

  //   const source = 'var valueNumeric=34;';

  //   jsExecutor.initialize(source);

  //   final evalRes = await jsExecutor.evaluate("valueNumeric");
  //   expect(evalRes, isA<JSEvalValue>());
  //   final evalValue = evalRes as JSEvalValue;
  //   expect(evalRes.value, isA<int>());
  //   expect(evalValue.value, 34);
  // });

  // test('return variable value double', () async {
  //   const source = 'var valueDouble=1.67;';

  //   jsExecutor.initialize(source);

  //   final evalRes = await jsExecutor.evaluate("valueDouble");
  //   expect(evalRes, isA<JSEvalValue>());
  //   final evalValue = evalRes as JSEvalValue;
  //   expect(evalRes.value, isA<double>());
  //   expect(evalValue.value, 1.67);
  // });

  // test('return execute Math', () async {
  //   final evalRes = await jsExecutor.evaluate("Math.pow(5,3)");
  //   expect(evalRes, isA<JSEvalValue>());
  //   final evalValue = evalRes as JSEvalValue;
  //   expect(evalRes.value, isA<int>());
  //   expect(evalValue.value, 125);
  // });

  // test('function call result int', () async {
  //   const source = '''
  //     function testFunc(val1, val2) {
  //       return val1+val2;
  //     }
  //   ''';
  //   jsExecutor.initialize(source);

  //   final evalRes = await jsExecutor.evaluate("testFunc(3,4);");
  //   expect(evalRes, isA<JSEvalValue>());
  //   final evalValue = evalRes as JSEvalValue;
  //   expect(evalValue.value, isA<int>());
  //   expect(evalValue.value, 7);
  // });

  // const promiseSource = '''
  //     // value <10 promise success with value
  //     // value  >10 promise reject "Error"
  //     function testFunc(value) {

  //       return new Promise(function(resolve, reject) {
  //         if (value <= 10) {
  //           resolve(value);
  //         } else {
  //           reject("Error("+value+")");
  //         }
  //       });

  //     }
  //   ''';

  // test('function call return a promise', () async {
  //   jsExecutor.initialize(promiseSource);

  //   final evalRes = await jsExecutor.evaluate("testFunc(10);");
  //   expect(evalRes, isA<JSEvalValue>());
  //   final evalValue = evalRes as JSEvalValue;
  //   //TODO : the result of a promise is wrapped into a string
  //   expect(evalValue.value, '10');
  // });

  // test('function call return a promise with error', () async {
  //   jsExecutor.initialize(promiseSource);

  //   final evalRes = await jsExecutor.evaluate("testFunc(11);");
  //   expect(evalRes, isA<JSEvalError>());
  //   final evalError = evalRes as JSEvalError;
  //   expect(evalError.message, '"Error(11)"');
  // });
}
