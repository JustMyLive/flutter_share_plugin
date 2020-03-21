import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_share_plugin/flutter_share_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion = 'Failed to get platform version.';
    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      platformVersion = await FlutterSharePlugin.platformVersion;
//    } on PlatformException {
//      platformVersion = 'Failed to get platform version.';
//    }

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
          child: Column(
            children: <Widget>[
              FlatButton(
                child: Text('Twitter'),
                onPressed: () async {
                  await FlutterSharePlugin().shareToTwitter(
                      msg: 'This is baidu', url: 'https://www.baidu.com');
                },
              ),
              FlatButton(
                child: Text('Facebook'),
                onPressed: () async {
                  await FlutterSharePlugin().shareToFacebook(
                      msg: 'This is baidu', url: 'https://www.baidu.com');
                },
              ),
              FlatButton(
                child: Text('Line'),
                onPressed: () async {
                  await FlutterSharePlugin().shareToLine(
                      msg: 'This is baidu', url: 'https://www.baidu.com');
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
//            var response = await FlutterSharePlugin().shareToTwitter(
//                url: 'https://github.com/lizhuoyuan', msg: 'abc');
//            if (response == 'success') {
//              print('navigate success');
//            }
          },
        ),
      ),
    );
  }
}
