@JS()
library js_registerer_web_callback;

import 'package:js/js.dart';

@JS('objectRegistered')
external set setObjectRegistered(void Function(dynamic) fun);

@JS()
external void objectRegistered(object);

@JS('callbackHost1')
external set setCallbackHost1(dynamic Function(dynamic) fun);

@JS()
external dynamic callbackHost1(dynamic);

@JS('callbackHost2')
external set setCallbackHost2(dynamic Function(dynamic) fun);

@JS()
external dynamic callbackHost2(dynamic);

@JS('callbackHost3')
external set setCallbackHost3(dynamic Function(dynamic) fun);

@JS()
external dynamic callbackHost3(dynamic);

@JS('callbackHost4')
external set setCallbackHost4(dynamic Function(dynamic) fun);

@JS()
external dynamic callbackHost4(dynamic);

@JS('callbackHost5')
external set setCallbackHost5(dynamic Function(dynamic) fun);

@JS()
external dynamic callbackHost5(dynamic);
