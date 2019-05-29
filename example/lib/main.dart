import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _absolutePath = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    /// uri can be of android scheme content or file
    /// for iOS PHAsset identifier is supported as well
    final uri = "content://media/external/images/media/43993";
    String absolutePath;
    try {
      absolutePath = await FlutterAbsolutePath.getAbsolutePath(uri);
    } on PlatformException {
      absolutePath = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _absolutePath = absolutePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_absolutePath\n'),
        ),
      ),
    );
  }
}
