import 'dart:async';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:platform/platform.dart';

typedef Future<dynamic> MessageHandler(String message);

class FlutterUmpush {
  factory FlutterUmpush() => _instance;

  @visibleForTesting
  FlutterUmpush.private(MethodChannel channel, Platform platform)
      : _channel = channel,
        _platform = platform;

  static final FlutterUmpush _instance = new FlutterUmpush.private(
      const MethodChannel('flutter_umupush'), const LocalPlatform());

  final MethodChannel _channel;
  final Platform _platform;

  MessageHandler _onMessage;
  MessageHandler _onLaunch;
  MessageHandler _onResume;
  MessageHandler _onToken;

  /// Sets up [MessageHandler] for incoming messages.
  void configure({
    MessageHandler onMessage,
    MessageHandler onLaunch,
    MessageHandler onResume,
    MessageHandler onToken,
  }) {
    _onMessage = onMessage;
    _onLaunch = onLaunch;
    _onResume = onResume;
    _onToken = onToken;
    _channel.setMethodCallHandler(_handleMethod);
    _channel.invokeMethod('configure');
  }

  void test() {
    _channel.invokeMethod('test');
  }

  Future<Null> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onToken":
        final String token = call.arguments;
        _onToken(token);
        return null;
      case "onMessage":
        final String message = call.arguments;
        print('onMessage: $message');
        _onMessage(message);
        return null;
      case "onLaunch":
        final String message = call.arguments;
        print('onLaunch: $message');
        _onLaunch(call.arguments.cast<String>());
        return null;
      case "onResume":
        final String message = call.arguments;
        print('onResume: $message');
        _onResume(call.arguments.cast<String>());
        return null;
      default:
        throw new UnsupportedError("Unrecognized JSON message");
    }
  }
}
