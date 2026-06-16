import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/day_data_editor.dart';
import '../../../data/repositories/day_record_repository.dart';
import '../../day/providers/day_persist_mixin.dart';
import '../../../shared/providers/repository_providers.dart';

/// Мгновенное обновление UI; SQLite — в фоне.
class TodayDayNotifier extends AsyncNotifier<DayData> with DayPersistMixin {
  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DayRecordRepository get _repo => ref.read(dayRecordRepositoryProvider);

  @override
  Future<DayData> build() => _repo.getDayData(_today);

  Future<void> reload() async {
    _repo.invalidateDayCache(_today);
    final fresh = await _repo.getDayData(_today);
    state = AsyncData(fresh);
  }

  void _commit(DayData next) {
    _repo.cacheDayData(next);
    state = AsyncData(next);
  }

  void markPrayed(String prayerKey) {
    final current = state.valueOrNull;
    if (current == null) return;
    _commit(applyPrayerUpdate(
      current,
      prayerKey,
      prayed: true,
      qazaPrayed: false,
    ));
    persistDayAction(() => _repo.markPrayer(
          date: _today,
          prayerKey: prayerKey,
          prayed: true,
        ));
  }

  void markMissed(String prayerKey) {
    final current = state.valueOrNull;
    if (current == null) return;
    _commit(applyPrayerUpdate(
      current,
      prayerKey,
      prayed: false,
      qazaPrayed: false,
    ));
    persistDayAction(() => _repo.markPrayer(
          date: _today,
          prayerKey: prayerKey,
          prayed: false,
        ));
  }

  void markQaza(String prayerKey) {
    final current = state.valueOrNull;
    if (current == null) return;
    _commit(applyPrayerUpdate(
      current,
      prayerKey,
      prayed: false,
      qazaPrayed: true,
    ));
    persistDayAction(() => _repo.markQaza(date: _today, prayerKey: prayerKey));
  }

  void setHabit(String habitKey, bool value) {
    final current = state.valueOrNull;
    if (current == null) return;
    _commit(applyHabitUpdate(current, habitKey, value));
    persistDayAction(() => _repo.setHabit(
          date: _today,
          habitKey: habitKey,
          value: value,
        ));
  }

  void toggleHabit(String habitKey) {
    final current = state.valueOrNull;
    if (current == null) return;
    final currentValue = current.habitValue(habitKey) ?? false;
    setHabit(habitKey, !currentValue);
  }

  void updateMood(int moodPercent) {
    final current = state.valueOrNull;
    if (current == null) return;
    _commit(applyMoodUpdate(current, moodPercent));
    persistDayAction(() => _repo.updateMood(_today, moodPercent));
  }
}

final todayDayNotifierProvider =
    AsyncNotifierProvider<TodayDayNotifier, DayData>(TodayDayNotifier.new);
