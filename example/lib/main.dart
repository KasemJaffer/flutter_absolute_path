import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_absolute_path/flutter_absolute_path.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<File> _files;

  @override
  void initState() {
    super.initState();
    init();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> init() async {

    List<File> files = [];
    files.add(
        File(
            await FlutterAbsolutePath.getAbsolutePath("content://media/external/images/media/41")
        )
    );
    files.add(
        File(
            await FlutterAbsolutePath.getAbsolutePath("content://com.android.providers.media.documents/document/image%3A41")
        )
    );

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _files = files;
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
          child: Text('Running on: $_files\n'),
        ),
      ),
    );
  }
}
