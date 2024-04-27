import 'package:flutter/services.dart';

class NativeSound {
  static const MethodChannel _channel = MethodChannel('com.example.app/ringtone');

  static Future<void> playDefaultNotificationSound() async {
    try {
      await _channel.invokeMethod('playNotificationSound');
    } catch (e) {
      print("Failed to invoke method: $e");
    }
  }
}
