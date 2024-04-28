import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/notification_preferences_manager.dart';

// 状態更新用のProvider

// 新規通知の有無を管理するProvider
final newNotificationsProvider = StateProvider<bool>((ref) {
  // SharedPreferencesからダークモードの状態を取得する
  return NotificationPreferencesManager.getNewNotifications() ?? false;
});

// 通知数を管理するProvider
final notificationCountProvider = StateProvider<int>((ref) {
  // SharedPreferencesからダークモードの状態を取得する
  return NotificationPreferencesManager.getNotificationCount() ?? 0;
});
