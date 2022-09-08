import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:native_add/natives_add.dart';

class TestingFFI extends StatefulWidget {
  final int firstnum;
  final int secondnum;
  
  const TestingFFI({Key? key, required this.firstnum, required this.secondnum}) : super(key: key);

  @override
  State<TestingFFI> createState() => _TestingFFIState();
}

class _TestingFFIState extends State<TestingFFI> {
  int result = 0;
  static const MethodChannel _channel = MethodChannel('native_add');
  final DynamicLibrary nativeAddLib = Platform.isAndroid
        ? DynamicLibrary.open('libnative_add.so')
        : DynamicLibrary.process();
  String _platformVersion = 'Unknown';
  int counter = 0;
  
  
  _cobaNativ(int firstnum, int secondnum){
    final int Function(int x, int y) nativeAdd = nativeAddLib
        .lookup<NativeFunction<Int32 Function(Int32, Int32)>>('native_add')
        .asFunction();
    
    result = nativeAdd(firstnum,secondnum);
    return result;
  }
     
  @override
  void initState() {
    // TODO: implement initState
    _cobaNativ(widget.firstnum, widget.secondnum);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
    child: Text("INI HASIL TESTING FFI : $result"),
    );
  }
}