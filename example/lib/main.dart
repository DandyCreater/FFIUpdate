import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:native_add/native_add.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const MethodChannel _channel = MethodChannel('native_add');
  final DynamicLibrary nativeAddLib = Platform.isAndroid
        ? DynamicLibrary.open('libnative_add.so')
        : DynamicLibrary.process();
  String _platformVersion = 'Unknown';
  int counter = 0;

  // NativeAdd nativeAdd = NativeAdd();
  

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  _cobaNativ(int xcoba, int ycoba){
    final int Function(int x, int y) nativeAdd = nativeAddLib
        .lookup<NativeFunction<Int32 Function(Int32, Int32)>>('native_add')
        .asFunction();
    
    return nativeAdd(xcoba,ycoba);
  }

  static Future<String?> get platformVersion2 async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await platformVersion2 ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
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
          child: 
          // Text(nativeAdd.toString()),
          Text('1 + 2 == $counter'),
          // Text('Running on: $_platformVersion\n'),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () { 
          setState(() {
            counter = _cobaNativ(1,2);
          });
          
         },child: const Text('+')),
      ),
    );
  }
}
