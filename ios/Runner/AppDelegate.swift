import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private let channel = "com.example.app/notifications"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)

    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
      if granted {
        DispatchQueue.main.async {
          application.registerForRemoteNotifications()
        }
      }
    }

    UNUserNotificationCenter.current().delegate = self

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }

  // 通知を受け取った際に通知音を鳴らし、Flutterにメッセージを送る
  override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    if let aps = userInfo["aps"] as? [String: AnyObject], let alert = aps["alert"] as? [String: AnyObject] {
      let title = alert["title"] as? String
      let body = alert["body"] as? String

      // Flutterにメッセージを送る
      let flutterViewController = window?.rootViewController as! FlutterViewController
      let channel = FlutterMethodChannel(name: self.channel, binaryMessenger: flutterViewController.binaryMessenger)
      channel.invokeMethod("onMessage", arguments: ["title": title, "body": body])
    }
    completionHandler([.alert, .sound])
  }

  // 通知をタップした際の処理
  override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    if let aps = userInfo["aps"] as? [String: AnyObject], let alert = aps["alert"] as? [String: AnyObject] {
      let title = alert["title"] as? String
      let body = alert["body"] as? String

      // Flutterにメッセージを送る
      let flutterViewController = window?.rootViewController as! FlutterViewController
      let channel = FlutterMethodChannel(name: self.channel, binaryMessenger: flutterViewController.binaryMessenger)
      channel.invokeMethod("onNotificationTap", arguments: ["title": title, "body": body])
    }
    completionHandler()
  }
}
