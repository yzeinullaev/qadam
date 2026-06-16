import 'package:drift/drift.dart';

import '../../core/constants/habit_keys.dart';
import '../../core/constants/mvp_constants.dart';
import '../../core/utils/day_status_calculator.dart';
import '../../core/utils/life_week_utils.dart';
import '../../core/utils/score_calculator.dart';
import '../../shared/models/day_status.dart';
import '../local/app_database.dart';

/// Full day data bundle for UI and stats.
class DayData {
  const DayData({
    required this.date,
    required this.dayRecord,
    required this.prayerRecords,
    required this.habitRecords,
    required this.activePrayerKeys,
    required this.activeHabitKeys,
    required this.habitSettings,
  });

  final DateTime date;
  final DayRecord? dayRecord;
  final List<PrayerRecord> prayerRecords;
  final List<HabitRecord> habitRecords;
  final List<String> activePrayerKeys;
  final List<String> activeHabitKeys;
  final List<HabitSetting> habitSettings;

  DayStatus get status => calculateDayStatus(
        activePrayerKeys: activePrayerKeys,
        prayerRecords: prayerRecords
            .map(
              (r) => PrayerSnapshot(
                prayerKey: r.prayerKey,
                prayed: r.prayed,
                qazaPrayed: r.qazaPrayed,
                prayedAt: r.prayedAt,
              ),
            )
            .toList(),
      );

  int get completedPrayers => prayerRecords
      .where((r) => r.prayed && activePrayerKeys.contains(r.prayerKey))
      .length;

  int get totalActivePrayers => activePrayerKeys.length;

  double get completionScore => calculateCompletionScore(
        completedActivePrayers: completedPrayers,
        totalActivePrayers: totalActivePrayers,
      );

  double get berekeScore {
    final missed = prayerRecords
        .where((r) => activePrayerKeys.contains(r.prayerKey) && !r.prayed)
        .toList();
    final missedWithQaza = missed.where((r) => r.qazaPrayed).length;

    final quranActive = activeHabitKeys.contains(HabitKeys.quran);
    final sadaqaActive = activeHabitKeys.contains(HabitKeys.sadaqa);

    var completedHabits = 0;
    if (dayRecord?.quranRead == true && quranActive) completedHabits++;
    if (dayRecord?.sadaqaDone == true && sadaqaActive) completedHabits++;
    if (dayRecord?.zikrDone == true &&
        activeHabitKeys.contains(HabitKeys.zikr)) {
      completedHabits++;
    }
    for (final hr in habitRecords) {
      if (hr.completed &&
          activeHabitKeys.contains(hr.habitKey) &&
          hr.habitKey != HabitKeys.quran &&
          hr.habitKey != HabitKeys.sadaqa &&
          hr.habitKey != HabitKeys.zikr) {
        completedHabits++;
      }
    }

    return calculateBerekeScore(
      completedActivePrayers: completedPrayers,
      totalActivePrayers: totalActivePrayers,
      missedWithQazaClosed: missedWithQaza,
      totalMissed: missed.length,
      quranDone: dayRecord?.quranRead ?? false,
      quranActive: quranActive,
      sadaqaDone: dayRecord?.sadaqaDone ?? false,
      sadaqaActive: sadaqaActive,
      completedHabits: completedHabits,
      totalActiveHabits: activeHabitKeys.length,
    );
  }

  bool? habitValue(String habitKey) {
    switch (habitKey) {
      case HabitKeys.quran:
        return dayRecord?.quranRead;
      case HabitKeys.sadaqa:
        return dayRecord?.sadaqaDone;
      case HabitKeys.zikr:
        return dayRecord?.zikrDone;
      default:
        return habitRecords
            .where((r) => r.habitKey == habitKey)
            .firstOrNull
            ?.completed;
    }
  }

  String habitTitle(String habitKey) {
    final setting =
        habitSettings.where((h) => h.habitKey == habitKey).firstOrNull;
    if (setting == null) return habitKey;
    if (setting.habitKey == HabitKeys.custom &&
        setting.customTitle != null &&
        setting.customTitle!.isNotEmpty) {
      return setting.customTitle!;
    }
    return setting.title;
  }
}

class _SettingsCache {
  _SettingsCache({
    required this.prayerKeys,
    required this.habitKeys,
    required this.habitSettings,
  });

  final List<String> prayerKeys;
  final List<String> habitKeys;
  final List<HabitSetting> habitSettings;
}

class DayRecordRepository {
  DayRecordRepository(this._db);

  final AppDatabase _db;
  _SettingsCache? _settingsCache;
  final Map<String, DayData> _dayCache = {};
  Future<void> _writeQueue = Future.value();

  /// Запись в SQLite — только мутации, строго по очереди.
  Future<void> _enqueueWrite(Future<void> Function() action) {
    final run = _writeQueue.then((_) => action());
    _writeQueue = run.then((_) {}, onError: (_) {});
    return run;
  }

  void invalidateSettingsCache() {
    _settingsCache = null;
    _dayCache.clear();
  }

  void invalidateDayCache([DateTime? date]) {
    if (date == null) {
      _dayCache.clear();
      return;
    }
    _dayCache.remove(LifeWeekUtils.dateKey(date));
  }

  /// Синхронный кэш после optimistic UI — чтения не ходят в SQLite.
  void cacheDayData(DayData data) {
    _dayCache[LifeWeekUtils.dateKey(data.date)] = data;
  }

  Future<_SettingsCache> _loadSettings() async {
    if (_settingsCache != null) return _settingsCache!;
    final prayers = await _db.getActivePrayerSettings();
    final habits = await _db.getActiveHabitSettings();
    _settingsCache = _SettingsCache(
      prayerKeys: prayers
          .map((p) => p.prayerKey)
          .where(MvpConstants.isMvpPrayer)
          .toList(),
      habitKeys: habits
          .map((h) => h.habitKey)
          .where(MvpConstants.isMvpHabit)
          .toList(),
      habitSettings:
          habits.where((h) => MvpConstants.isMvpHabit(h.habitKey)).toList(),
    );
    return _settingsCache!;
  }

  Future<DayData> getDayData(DateTime date) async {
    final dateKey = LifeWeekUtils.dateKey(date);
    final cached = _dayCache[dateKey];
    if (cached != null) return cached;

    final data = await _loadDayDataFromDb(date);
    _dayCache[dateKey] = data;
    return data;
  }

  Future<DayData> _loadDayDataFromDb(DateTime date) async {
    final settings = await _loadSettings();
    final dateKey = LifeWeekUtils.dateKey(date);
    final dayRecord = await _db.getDayRecordByDate(dateKey);

    List<PrayerRecord> prayers = [];
    List<HabitRecord> habits = [];
    if (dayRecord != null) {
      prayers = await _db.getPrayerRecordsForDay(dayRecord.id);
      habits = await _db.getHabitRecordsForDay(dayRecord.id);
    }

    return DayData(
      date: date,
      dayRecord: dayRecord,
      prayerRecords: prayers,
      habitRecords: habits,
      activePrayerKeys: settings.prayerKeys,
      activeHabitKeys: settings.habitKeys,
      habitSettings: settings.habitSettings,
    );
  }

  /// Быстрый расчёт карты жизни — один проход по БД.
  Future<List<WeekStatus>> getLifeMapWeekStatuses({
    required DateTime birthDate,
    required int lifeExpectancy,
  }) async {
    final totalWeeks = LifeWeekUtils.totalWeeks(lifeExpectancy);
    final currentWeek = LifeWeekUtils.currentWeekIndex(birthDate);
    final statuses = List.generate(totalWeeks, (i) {
      if (i > currentWeek) return WeekStatus.future;
      if (i == currentWeek) return WeekStatus.current;
      return WeekStatus.empty;
    });

    final settings = await _loadSettings();
    final activeKeys = settings.prayerKeys;

    final dayRecords = await _db.getAllDayRecords();
    if (dayRecords.isEmpty) return statuses;

    final allPrayers = await _db.getAllPrayerRecords();
    final prayersByDayId = <int, List<PrayerRecord>>{};
    for (final p in allPrayers) {
      prayersByDayId.putIfAbsent(p.dayRecordId, () => []).add(p);
    }

    final weekStatusesMap = <int, List<DayStatus>>{};

    for (final dr in dayRecords) {
      final date = LifeWeekUtils.parseDateKey(dr.date);
      final weekIdx = LifeWeekUtils.weekIndexForDate(
        birthDate: birthDate,
        date: date,
      );
      if (weekIdx < 0 || weekIdx > currentWeek || weekIdx >= totalWeeks) {
        continue;
      }

      final prayers = prayersByDayId[dr.id] ?? [];
      final hasData = prayers.isNotEmpty ||
          dr.moodPercent != null ||
          dr.quranRead != null ||
          dr.sadaqaDone != null ||
          dr.zikrDone != null ||
          (dr.note != null && dr.note!.isNotEmpty);

      if (!hasData) continue;

      final snapshots = prayers
          .map(
            (r) => PrayerSnapshot(
              prayerKey: r.prayerKey,
              prayed: r.prayed,
              qazaPrayed: r.qazaPrayed,
            ),
          )
          .toList();

      final dayStatus = calculateDayStatus(
        activePrayerKeys: activeKeys,
        prayerRecords: snapshots,
      );

      final weekStart = LifeWeekUtils.weekStartForIndex(
        birthDate: birthDate,
        weekIndex: weekIdx,
      );
      final dayOffset = date.difference(weekStart).inDays.clamp(0, 6);

      weekStatusesMap.putIfAbsent(weekIdx, () => List.filled(7, DayStatus.empty));
      weekStatusesMap[weekIdx]![dayOffset] = dayStatus;
    }

    for (final entry in weekStatusesMap.entries) {
      statuses[entry.key] = calculateWeekStatus(
        dayStatuses: entry.value,
        isFuture: false,
        isCurrent: entry.key == currentWeek,
      );
    }

    return statuses;
  }

  Future<int> _ensureDayRecord(DateTime date) async {
    final dateKey = LifeWeekUtils.dateKey(date);
    final existing = await _db.getDayRecordByDate(dateKey);
    if (existing != null) return existing.id;

    final now = DateTime.now();
    return _db.upsertDayRecord(
      DayRecordsCompanion.insert(
        date: dateKey,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> markPrayer({
    required DateTime date,
    required String prayerKey,
    required bool prayed,
    bool qazaPrayed = false,
  }) =>
      _enqueueWrite(() async {
        final dayId = await _ensureDayRecord(date);
        final now = DateTime.now();
        final existing = (await _db.getPrayerRecordsForDay(dayId))
            .where((r) => r.prayerKey == prayerKey)
            .firstOrNull;

        await _db.upsertPrayerRecord(
          PrayerRecordsCompanion(
            id: existing != null ? Value(existing.id) : const Value.absent(),
            dayRecordId: Value(dayId),
            prayerKey: Value(prayerKey),
            prayed: Value(prayed),
            qazaPrayed: Value(qazaPrayed || (existing?.qazaPrayed ?? false)),
            prayedAt: prayed ? Value(now) : const Value.absent(),
            createdAt:
                existing != null ? Value(existing.createdAt) : Value(now),
            updatedAt: Value(now),
          ),
        );
      });

  Future<void> markQaza({
    required DateTime date,
    required String prayerKey,
  }) =>
      _enqueueWrite(() async {
        final dayId = await _ensureDayRecord(date);
        final now = DateTime.now();
        final existing = (await _db.getPrayerRecordsForDay(dayId))
            .where((r) => r.prayerKey == prayerKey)
            .firstOrNull;

        await _db.upsertPrayerRecord(
          PrayerRecordsCompanion(
            id: existing != null ? Value(existing.id) : const Value.absent(),
            dayRecordId: Value(dayId),
            prayerKey: Value(prayerKey),
            prayed: const Value(false),
            qazaPrayed: const Value(true),
            prayedAt: Value(now),
            createdAt:
                existing != null ? Value(existing.createdAt) : Value(now),
            updatedAt: Value(now),
          ),
        );
      });

  Future<void> updateMood(DateTime date, int moodPercent) =>
      _enqueueWrite(() async {
        final dayId = await _ensureDayRecord(date);
        final now = DateTime.now();
        final dateKey = LifeWeekUtils.dateKey(date);
        final existing = await _db.getDayRecordByDate(dateKey);

        await _db.upsertDayRecord(
          DayRecordsCompanion(
            id: Value(dayId),
            date: Value(dateKey),
            moodPercent: Value(moodPercent.clamp(0, 100)),
            createdAt:
                existing != null ? Value(existing.createdAt) : Value(now),
            updatedAt: Value(now),
          ),
        );
      });

  Future<void> updateNote(DateTime date, String note) =>
      _enqueueWrite(() async {
        final dayId = await _ensureDayRecord(date);
        final now = DateTime.now();
        final dateKey = LifeWeekUtils.dateKey(date);
        final existing = await _db.getDayRecordByDate(dateKey);

        await _db.upsertDayRecord(
          DayRecordsCompanion(
            id: Value(dayId),
            date: Value(dateKey),
            note: Value(note.isEmpty ? null : note),
            createdAt:
                existing != null ? Value(existing.createdAt) : Value(now),
            updatedAt: Value(now),
          ),
        );
      });

  Future<void> setHabit({
    required DateTime date,
    required String habitKey,
    required bool? value,
  }) =>
      _enqueueWrite(() async {
        if (value == null) return;

        if (habitKey == HabitKeys.quran ||
            habitKey == HabitKeys.sadaqa ||
            habitKey == HabitKeys.zikr) {
          await toggleHabitFlag(date: date, field: habitKey, value: value);
          return;
        }

        await toggleCustomHabit(
          date: date,
          habitKey: habitKey,
          completed: value,
        );
      });

  Future<void> toggleHabitFlag({
    required DateTime date,
    required String field,
    required bool value,
  }) async {
    final dayId = await _ensureDayRecord(date);
    final now = DateTime.now();
    final dateKey = LifeWeekUtils.dateKey(date);
    final existing = await _db.getDayRecordByDate(dateKey);

    final companion = DayRecordsCompanion(
      id: Value(dayId),
      date: Value(dateKey),
      createdAt: existing != null ? Value(existing.createdAt) : Value(now),
      updatedAt: Value(now),
    );

    switch (field) {
      case HabitKeys.quran:
        await _db.upsertDayRecord(companion.copyWith(quranRead: Value(value)));
      case HabitKeys.sadaqa:
        await _db.upsertDayRecord(companion.copyWith(sadaqaDone: Value(value)));
      case HabitKeys.zikr:
        await _db.upsertDayRecord(companion.copyWith(zikrDone: Value(value)));
    }
  }

  Future<void> toggleCustomHabit({
    required DateTime date,
    required String habitKey,
    required bool completed,
  }) async {
    final dayId = await _ensureDayRecord(date);
    final now = DateTime.now();
    final existing = (await _db.getHabitRecordsForDay(dayId))
        .where((r) => r.habitKey == habitKey)
        .firstOrNull;

    await _db.upsertHabitRecord(
      HabitRecordsCompanion(
        id: existing != null ? Value(existing.id) : const Value.absent(),
        dayRecordId: Value(dayId),
        habitKey: Value(habitKey),
        completed: Value(completed),
        createdAt: existing != null ? Value(existing.createdAt) : Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<List<DayData>> getWeekData({
    required DateTime birthDate,
    required int weekIndex,
  }) async {
    final days = LifeWeekUtils.daysInWeek(
      birthDate: birthDate,
      weekIndex: weekIndex,
    );
    final results = <DayData>[];
    for (final day in days) {
      results.add(await getDayData(day));
    }
    return results;
  }

  Future<List<DayData>> getAllDayData() async {
    final records = await _db.getAllDayRecords();
    return Future.wait(
      records.map((r) => getDayData(LifeWeekUtils.parseDateKey(r.date))),
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) return iterator.current;
    return null;
  }
}
