import 'package:drift/drift.dart';

import '../../core/constants/habit_keys.dart';
import '../../core/utils/life_week_utils.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/day_record_repository.dart';

/// Мгновенные обновления DayData в памяти — без ожидания SQLite.
DayData applyPrayerUpdate(
  DayData data,
  String prayerKey, {
  required bool prayed,
  required bool qazaPrayed,
}) {
  final now = DateTime.now();
  final records = List<PrayerRecord>.from(data.prayerRecords);
  final index = records.indexWhere((r) => r.prayerKey == prayerKey);
  final dayId = data.dayRecord?.id ?? 0;

  if (index >= 0) {
    records[index] = records[index].copyWith(
      prayed: prayed,
      qazaPrayed: qazaPrayed,
      prayedAt: prayed || qazaPrayed ? Value(now) : const Value(null),
      updatedAt: now,
    );
  } else {
    records.add(
      PrayerRecord(
        id: 0,
        dayRecordId: dayId,
        prayerKey: prayerKey,
        prayed: prayed,
        qazaPrayed: qazaPrayed,
        prayedAt: prayed || qazaPrayed ? now : null,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  return DayData(
    date: data.date,
    dayRecord: data.dayRecord,
    prayerRecords: records,
    habitRecords: data.habitRecords,
    activePrayerKeys: data.activePrayerKeys,
    activeHabitKeys: data.activeHabitKeys,
    habitSettings: data.habitSettings,
  );
}

DayData applyHabitUpdate(DayData data, String habitKey, bool value) {
  final now = DateTime.now();

  switch (habitKey) {
    case HabitKeys.quran:
    case HabitKeys.sadaqa:
    case HabitKeys.zikr:
      final dateKey = LifeWeekUtils.dateKey(data.date);
      final dayRecord = data.dayRecord?.copyWith(
            quranRead: habitKey == HabitKeys.quran
                ? Value(value)
                : const Value.absent(),
            sadaqaDone: habitKey == HabitKeys.sadaqa
                ? Value(value)
                : const Value.absent(),
            zikrDone: habitKey == HabitKeys.zikr
                ? Value(value)
                : const Value.absent(),
            updatedAt: now,
          ) ??
          DayRecord(
            id: 0,
            date: dateKey,
            quranRead: habitKey == HabitKeys.quran ? value : null,
            sadaqaDone: habitKey == HabitKeys.sadaqa ? value : null,
            zikrDone: habitKey == HabitKeys.zikr ? value : null,
            createdAt: now,
            updatedAt: now,
          );

      return DayData(
        date: data.date,
        dayRecord: dayRecord,
        prayerRecords: data.prayerRecords,
        habitRecords: data.habitRecords,
        activePrayerKeys: data.activePrayerKeys,
        activeHabitKeys: data.activeHabitKeys,
        habitSettings: data.habitSettings,
      );

    default:
      final records = List<HabitRecord>.from(data.habitRecords);
      final index = records.indexWhere((r) => r.habitKey == habitKey);
      final dayId = data.dayRecord?.id ?? 0;

      if (index >= 0) {
        records[index] = records[index].copyWith(
          completed: value,
          updatedAt: now,
        );
      } else {
        records.add(
          HabitRecord(
            id: 0,
            dayRecordId: dayId,
            habitKey: habitKey,
            completed: value,
            createdAt: now,
            updatedAt: now,
          ),
        );
      }

      return DayData(
        date: data.date,
        dayRecord: data.dayRecord,
        prayerRecords: data.prayerRecords,
        habitRecords: records,
        activePrayerKeys: data.activePrayerKeys,
        activeHabitKeys: data.activeHabitKeys,
        habitSettings: data.habitSettings,
      );
  }
}

DayData applyMoodUpdate(DayData data, int moodPercent) {
  final now = DateTime.now();
  final dateKey = LifeWeekUtils.dateKey(data.date);
  final dayRecord = data.dayRecord?.copyWith(
        moodPercent: Value(moodPercent),
        updatedAt: now,
      ) ??
      DayRecord(
        id: 0,
        date: dateKey,
        moodPercent: moodPercent,
        createdAt: now,
        updatedAt: now,
      );

  return DayData(
    date: data.date,
    dayRecord: dayRecord,
    prayerRecords: data.prayerRecords,
    habitRecords: data.habitRecords,
    activePrayerKeys: data.activePrayerKeys,
    activeHabitKeys: data.activeHabitKeys,
    habitSettings: data.habitSettings,
  );
}

DayData applyNoteUpdate(DayData data, String note) {
  final now = DateTime.now();
  final dateKey = LifeWeekUtils.dateKey(data.date);
  final dayRecord = data.dayRecord?.copyWith(
        note: Value(note.isEmpty ? null : note),
        updatedAt: now,
      ) ??
      DayRecord(
        id: 0,
        date: dateKey,
        note: note.isEmpty ? null : note,
        createdAt: now,
        updatedAt: now,
      );

  return DayData(
    date: data.date,
    dayRecord: dayRecord,
    prayerRecords: data.prayerRecords,
    habitRecords: data.habitRecords,
    activePrayerKeys: data.activePrayerKeys,
    activeHabitKeys: data.activeHabitKeys,
    habitSettings: data.habitSettings,
  );
}
