import 'package:shared_preferences/shared_preferences.dart';

import '../providers/notification_provider.dart';

class NotificationPreferencesManager {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // バックグラウンド時に新規通知をセット
  static Future<void> setNewNotificationsForBackground(bool value) async {
    await _prefs?.setBool('hasNewNotifications', value) ?? Future.value();
  }

  // 新規通知を取得
  static bool? getNewNotifications() {
    return _prefs?.getBool('hasNewNotifications');
  }

  // 新規通知をセット
  static Future<void> setNewNotifications(ref,bool value) async {
    await _prefs?.setBool('hasNewNotifications', value) ?? Future.value();
    ref.read(newNotificationsProvider.notifier).state = value;
  }

  // 通知数を取得
  static int? getNotificationCount() {
    return _prefs?.getInt('notificationCount');
  }

  // 通知数を足す
  static Future<void> setNotificationCountAdd(ref) async {
    final count = getNotificationCount() ?? 0;
    final newValue = count + 1;
     await _prefs?.setInt('notificationCount', newValue) ?? Future.value();
    // セット時にreverpodの値も更新(画面の描画用)
     ref.read(notificationCountProvider.notifier).state = newValue;
  }

  // バックグラウンド時に通知数を足す
  static Future<void> setNotificationCountAddForBackground() async {
    final count = getNotificationCount() ?? 0;
    final newValue = count + 1;
    await _prefs?.setInt('notificationCount', newValue) ?? Future.value();
  }

  // 通知数を引く
  // 通知数を減らすが、0未満にはならない
  static Future<void> setNotificationCountDraw(ref) async {
    final count = getNotificationCount() ?? 0;
    final newValue = count - 1;
    // 通知数が0より大きい場合のみ、通知数を減らす
    if (count > 0) {
      await _prefs?.setInt('notificationCount', count - 1) ?? Future.value();
      // セット時にreverpodの値も更新(画面の描画用)
      ref.read(notificationCountProvider.notifier).state = newValue;
    }
    return Future.value();  // 通知数が0の場合、何もしない
  }

  // 全てをリセット(開発用)
  static Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // 全てのSharedPreferencesをログに出力
  static Future<void> logAllSharedPreferences() async {
    final keys = _prefs?.getKeys();
    if (keys != null) {
      for (String key in keys) {
        var value = _prefs?.get(key);
        print('$key: $value');
      }
    }
  }
}
