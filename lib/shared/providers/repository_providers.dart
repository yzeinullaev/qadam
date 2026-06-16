import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/app_database.dart';
import '../../data/repositories/day_record_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/user_profile_repository.dart';
import '../../features/today/providers/today_day_notifier.dart';
import 'database_provider.dart';

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository(ref.watch(databaseProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(databaseProvider));
});

final dayRecordRepositoryProvider = Provider<DayRecordRepository>((ref) {
  return DayRecordRepository(ref.watch(databaseProvider));
});

final activePrayerSettingsProvider = FutureProvider<List<PrayerSetting>>((ref) {
  return ref.watch(databaseProvider).getActivePrayerSettings();
});

final activeHabitSettingsProvider = FutureProvider<List<HabitSetting>>((ref) {
  return ref.watch(databaseProvider).getActiveHabitSettings();
});

final todayDayDataProvider = Provider<AsyncValue<DayData>>((ref) {
  return ref.watch(todayDayNotifierProvider);
});
