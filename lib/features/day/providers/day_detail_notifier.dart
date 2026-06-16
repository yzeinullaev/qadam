import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/day_data_editor.dart';
import '../../../core/utils/life_week_utils.dart';
import '../../../data/repositories/day_record_repository.dart';
import '../../../shared/providers/repository_providers.dart';
import 'day_persist_mixin.dart';

class DayDetailNotifier extends FamilyAsyncNotifier<DayData, String>
    with DayPersistMixin {
  DayRecordRepository get _repo => ref.read(dayRecordRepositoryProvider);

  DateTime get _date => LifeWeekUtils.parseDateKey(arg);

  @override
  Future<DayData> build(String dateKey) => _repo.getDayData(_date);

  Future<void> reload() async {
    _repo.invalidateDayCache(_date);
    state = AsyncData(await _repo.getDayData(_date));
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
          date: _date,
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
          date: _date,
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
    persistDayAction(() => _repo.markQaza(date: _date, prayerKey: prayerKey));
  }

  void setHabit(String habitKey, bool value) {
    final current = state.valueOrNull;
    if (current == null) return;
    _commit(applyHabitUpdate(current, habitKey, value));
    persistDayAction(() => _repo.setHabit(
          date: _date,
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
    persistDayAction(() => _repo.updateMood(_date, moodPercent));
  }
}

final dayDetailNotifierProvider =
    AsyncNotifierProvider.family<DayDetailNotifier, DayData, String>(
  DayDetailNotifier.new,
);

final dayDataProvider = Provider.family<AsyncValue<DayData>, String>((ref, dateKey) {
  return ref.watch(dayDetailNotifierProvider(dateKey));
});
