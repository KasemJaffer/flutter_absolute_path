import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

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
    /// uri can be of android scheme content or file
    /// for iOS PHAsset identifier is supported as well

    List<Asset> assets = await selectImagesFromGallery();
    List<File> files = [];
    for (Asset asset in assets) {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
      files.add(File(filePath));
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _files = files;
    });
  }

  Future<List<Asset>> selectImagesFromGallery() async {
    return await MultiImagePicker.pickImages(
      maxImages: 65536,
      enableCamera: true,
      materialOptions: MaterialOptions(
        actionBarColor: "#FF147cfa",
        statusBarColor: "#FF147cfa",
      ),
    );
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
