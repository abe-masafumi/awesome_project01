import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationProvider = StateProvider<bool>((ref) => false);
final notificationCounterProvider = StateProvider<int>((ref) => 0);

final badgeVisibleProvider = StateProvider<bool>((ref) => false);
final counterProvider = StateProvider<int>((ref) => 0);