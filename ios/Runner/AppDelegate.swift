import UIKit
import Flutter
import FirebaseCore
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)

    let center = UNUserNotificationCenter.current()
    center.delegate = self

    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if let error = error {
            print("通知の権限リクエストでエラーが発生しました: \(error)")
        }
    }

    // MethodChannelの設定
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.yourcompany.notifications",
                                       binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
        if call.method == "triggerNotification" {
            self?.triggerNotification()
            result(nil)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // フォアグラウンドで通知を受け取った時に呼ばれるデリゲートメソッド
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // 通知バナー表示、通知音の再生を指定
    completionHandler([.alert, .sound])
  }

  // 通知をトリガーするメソッド
  @objc func triggerNotification() {
    let content = UNMutableNotificationContent()
    content.title = "新しいメッセージがあります"
    content.body = "あなたに新しいメッセージが届きました"
    content.sound = UNNotificationSound.default

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("通知のトリガーに失敗しました: \(error)")
        }
    }
  }
}
