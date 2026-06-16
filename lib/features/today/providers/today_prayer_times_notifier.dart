import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/prayer_time_service.dart';

/// Время намаза загружается один раз при открытии экрана (без invalidate на каждый rebuild).
class TodayPrayerTimesNotifier extends AsyncNotifier<PrayerTimeInfo?> {
  @override
  Future<PrayerTimeInfo?> build() {
    return ref.read(prayerTimeServiceProvider).getTodayPrayerTimes();
  }

  Future<void> reload() async {
    state = AsyncData(
      await ref.read(prayerTimeServiceProvider).getTodayPrayerTimes(),
    );
  }
}

final todayPrayerTimesNotifierProvider =
    AsyncNotifierProvider<TodayPrayerTimesNotifier, PrayerTimeInfo?>(
  TodayPrayerTimesNotifier.new,
);
