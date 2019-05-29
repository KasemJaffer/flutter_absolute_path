import 'dart:async';

import 'package:flutter/services.dart';

class FlutterAbsolutePath {
  static const MethodChannel _channel =
      const MethodChannel('flutter_absolute_path');

  static Future<String> getAbsolutePath(String uri) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'uri': uri,
    };
    final String path = await _channel.invokeMethod('getAbsolutePath', params);
    return path;
  }
}
