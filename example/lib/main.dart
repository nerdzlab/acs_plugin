import 'dart:developer';

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
  String? _viewId;

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

  Future<void> requestMicrophonePermissions() async {
    try {
      final result = await _acsPlugin.requestMicrophonePermissions();
      log('Microphone permissions is granted = ${result.toString()}');
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> requestCameraPermissions() async {
    try {
      final result = await _acsPlugin.requestCameraPermissions();
      log('Camera permissions is granted = ${result.toString()}');
    } catch (error) {
      log(error.toString());
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initAzure() async {
    try {
      final result = await _acsPlugin.initializeCall(
          token:
              "eyJhbGciOiJSUzI1NiIsImtpZCI6IkY1M0ZEODA0RThBNDhBQzg4Qjg3NTA3M0M4MzRCRDdGNzBCMzBENDUiLCJ4NXQiOiI5VF9ZQk9pa2lzaUxoMUJ6eURTOWYzQ3pEVVUiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZV8wMDAwMDAyNi03MWQyLWIxYmUtYTdhYy00NzNhMGQwMDA2YzIiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDM0MTEyMTUiLCJleHAiOjE3NDM0OTc2MTUsInJnbiI6Im5vIiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6Ijg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZSIsInJlc291cmNlTG9jYXRpb24iOiJub3J3YXkiLCJpYXQiOjE3NDM0MTEyMTV9.EkuqQKM99Lz6kZ7P2sWYhxGmj9vYRnhxijO-Uk6H104GWRqGjC9Lw7IU-xZtkBhFqF84-yED2w64oiF_QvvP07FjjgMKUjW1XvDftfVrs-RvR3pHE99G96GwIuJFt7Emd__3mNMkLUdP87GAu-SgZkUyo24s58pK_-zmidbyjwmOeOMyFplukA4VHuY_zd4v1BT1IaRvEJgQKDRvcptSTi268Igi4x-xHHq_X7SzLPNt7SDtkisUl6VI58Hapr6QHZUQAn_wZ4asLCbmTiRIKkdKHuhd21q06NdS1mSxZyRmXLNqELsulpiP4h00zSk_9AWCv6uoTiTse02RqAYFTA");
    } catch (error) {
      log(error.toString());
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> joinRoom() async {
    try {
      final result = await _acsPlugin.joinRoom(roomId: "99547464766727963");
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> leaveRoom() async {
    try {
      final result = await _acsPlugin.leaveRoomCall();
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> toggleMute() async {
    try {
      final result = await _acsPlugin.toggleMute();
      log('Call is muted = ${result.toString()}');
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> toggleSpeaker() async {
    try {
      final result = await _acsPlugin.toggleSpeaker();
      log('Speaker is enabled = ${result.toString()}');
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> _toggleVideo() async {
    String? viewId = await _acsPlugin.toggleLocalVideo();
    if (viewId != null) {
      setState(() {
        _viewId = viewId;
      });
    } else {
      setState(() {
        _viewId = null;
      });
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              child: Container(
                height: 40,
                width: 200,
                color: Colors.red,
                child: Text(
                  'Request microphone',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                requestMicrophonePermissions();
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              child: Container(
                height: 40,
                width: 200,
                color: Colors.red,
                child: Text(
                  'Request camera',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                requestCameraPermissions();
              },
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            InkWell(
              child: Container(
                height: 40,
                width: 200,
                color: Colors.red,
                child: Text(
                  'Join room',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                joinRoom();
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              child: Container(
                height: 40,
                width: 200,
                color: Colors.red,
                child: Text(
                  'Leave room',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                leaveRoom();
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              child: Container(
                height: 40,
                width: 200,
                color: Colors.red,
                child: Text(
                  'Toggle speaker',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                toggleSpeaker();
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              child: Container(
                height: 40,
                width: 200,
                color: Colors.red,
                child: Text(
                  'Toggle mute',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                toggleMute();
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              child: Container(
                height: 40,
                width: 200,
                color: Colors.red,
                child: Text(
                  'Toggle video',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                _toggleVideo();
              },
            ),
            _viewId != null
                ? Expanded(child: IosVideoView(viewId: _viewId!))
                : Container(height: 200, color: Colors.black),
            const SizedBox(height: 16),
            Text('Running on: $_platformVersion\n'),
          ],
        ),
      ),
    );
  }
}

final class IosVideoView extends StatelessWidget {
  final String viewId;

  const IosVideoView({super.key, required this.viewId});

  @override
  Widget build(BuildContext context) {
    return UiKitView(
      viewType: 'acs_video_view',
      creationParams: {'viewId': viewId},
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
