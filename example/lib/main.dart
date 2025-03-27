import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:acs_plugin/acs_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _acsPlugin = AcsPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _acsPlugin.getPlatformVersion() ?? 'Unknown platform version';
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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initAzure() async {
    try {
      final result = await _acsPlugin.initializeCall(
          token:
              "eyJhbGciOiJSUzI1NiIsImtpZCI6IkY1M0ZEODA0RThBNDhBQzg4Qjg3NTA3M0M4MzRCRDdGNzBCMzBENDUiLCJ4NXQiOiI5VF9ZQk9pa2lzaUxoMUJ6eURTOWYzQ3pEVVUiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZV8wMDAwMDAyNi03MWQyLWIxYmUtYTdhYy00NzNhMGQwMDA2YzIiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDMwNjUzNzgiLCJleHAiOjE3NDMxNTE3NzgsInJnbiI6Im5vIiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6Ijg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZSIsInJlc291cmNlTG9jYXRpb24iOiJub3J3YXkiLCJpYXQiOjE3NDMwNjUzNzh9.ygkwoEikEr-pFNAt_-30i70lm62R88iODBU2FiAjGZuZ6naPKkYSldUgd9eFrodosDUGPfWVEXqcNtGrClMguDZESFsZKFbngubRq9EV1RhN0mfHfSyANvJTyDuMnLzQFENMW-RCY2piFRqG4jKIlmjOJaghQcfOGrLylM5T_B6Y-LibbVdQWbn3IlvbrSVvLyB28Oue6A7jffvmzIqyI86wzoTnOa3ISJSHQHjFFu3Gc5RGJSak0FDMHINx17HVatFeZNUQn-di9wvm-j8bJ5NQX1IEo1LDqKVAN-hEgWFc6Z0H52FK70p46GHY-LxowDGZkUvpy5O8R_GsimLPQw");
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: Container(
                height: 40,
                width: 200,
                color: Colors.red,
                child: Text(
                  'Init Azure',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                initAzure();
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Text('Running on: $_platformVersion\n'),
          ],
        ),
      ),
    );
  }
}
