import 'package:flutter/material.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:test_js_runtime/proxy_handler/proxy_handler.dart';
import 'package:test_js_runtime/test_method.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JS executor demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'JS executor Home'),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatelessWidget {
  final String title;
  late JSRuntime jsRuntime;

  MyHomePage({Key? key, required this.title}) : super(key: key) {
    jsRuntime = JSRuntime();
    jsRuntime.initialize();
  }

  dynamic _repeatExecution() {
    const count = 1000;

    try {
      for (int i = 0; i < count; i++) {
        final call = _buildTest1(10000000 + i);
        call();
      }
      return "executed $count time";
    } catch (e) {
      return e.toString();
    }
  }

  dynamic Function() _buildTest1(dynamic valueInput) {
    dynamic test1() {
      callback(value) {
        return value;
      }

      final proxyHandler = ProxyHandler.withJSExecutor(jsRuntime, callback);
      final result = proxyHandler.getValueFromHost(valueInput);
      proxyHandler.dispose();
      return result;
    }

    return test1;
  }

  dynamic _test2() {
    callback(value) {
      return value;
    }

    final proxyHandler = ProxyHandler.withJSExecutor(jsRuntime, callback);
    final result = proxyHandler.calculate(10, 30);
    proxyHandler.dispose();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TestClassMethod(
            description: "proxyHandler.getValueFromHost(30)",
            execution: _buildTest1(30),
          ),
          TestClassMethod(
            description: "proxyHandler.getValueFromHost('valueString')",
            execution: _buildTest1('valueString'),
          ),
          TestClassMethod(
            description: "proxyHandler.calculate(10,30)",
            execution: _test2,
          ),
          TestClassMethod(
            description: "repeat proxyHandler.getValueFromHost(10000000)",
            execution: _repeatExecution,
          ),
        ],
      ),
    );
  }
}
