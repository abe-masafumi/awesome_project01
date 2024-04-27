package com.masa.awesome_project01

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.media.RingtoneManager
import android.media.Ringtone
import android.net.Uri

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.app/ringtone"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "playNotificationSound") {
                playNotificationSound()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun playNotificationSound() {
        val notification: Uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
        val ringtone: Ringtone = RingtoneManager.getRingtone(applicationContext, notification)
        ringtone.play()
    }
}
