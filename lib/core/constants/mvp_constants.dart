import 'habit_keys.dart';
import 'prayer_keys.dart';

/// Границы MVP-1: только обязательное и главное.
abstract final class MvpConstants {
  static const prayerKeys = PrayerKeys.defaultActive;
  static const habitKeys = HabitKeys.mvpActive;

  static bool isMvpPrayer(String key) => PrayerKeys.obligatory.contains(key);
  static bool isMvpHabit(String key) => HabitKeys.mvpActive.contains(key);
}
