import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    UserProfiles,
    PrayerSettings,
    HabitSettings,
    DayRecords,
    PrayerRecords,
    HabitRecords,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
      );

  // --- User profile ---

  Future<UserProfile?> getUserProfile() =>
      (select(userProfiles)..limit(1)).getSingleOrNull();

  Future<int> insertUserProfile(UserProfilesCompanion profile) =>
      into(userProfiles).insert(profile);

  Future<bool> updateUserProfile(UserProfilesCompanion profile) async {
    final id = profile.id.value;
    final updated =
        await (update(userProfiles)..where((t) => t.id.equals(id)))
            .write(profile);
    return updated > 0;
  }

  Future<List<PrayerRecord>> getAllPrayerRecords() =>
      select(prayerRecords).get();

  Future<List<HabitRecord>> getAllHabitRecords() => select(habitRecords).get();

  // --- Prayer settings ---

  Future<List<PrayerSetting>> getAllPrayerSettings() =>
      (select(prayerSettings)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<List<PrayerSetting>> getActivePrayerSettings() =>
      (select(prayerSettings)
            ..where((t) => t.isActive.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<void> upsertPrayerSetting(PrayerSettingsCompanion setting) =>
      into(prayerSettings).insertOnConflictUpdate(setting);

  // --- Habit settings ---

  Future<List<HabitSetting>> getAllHabitSettings() =>
      (select(habitSettings)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<List<HabitSetting>> getActiveHabitSettings() =>
      (select(habitSettings)
            ..where((t) => t.isActive.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<void> upsertHabitSetting(HabitSettingsCompanion setting) =>
      into(habitSettings).insertOnConflictUpdate(setting);

  // --- Day records ---

  Future<DayRecord?> getDayRecordByDate(String date) =>
      (select(dayRecords)..where((t) => t.date.equals(date)))
          .getSingleOrNull();

  Future<List<DayRecord>> getDayRecordsInRange(String from, String to) =>
      (select(dayRecords)
            ..where((t) => t.date.isBetweenValues(from, to))
            ..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .get();

  Future<int> upsertDayRecord(DayRecordsCompanion record) async {
    if (record.id.present) {
      await (update(dayRecords)..where((t) => t.id.equals(record.id.value)))
          .write(record);
      return record.id.value;
    }

    final existing = await getDayRecordByDate(record.date.value);
    if (existing != null) {
      await (update(dayRecords)..where((t) => t.id.equals(existing.id)))
          .write(record);
      return existing.id;
    }
    return into(dayRecords).insert(record);
  }

  // --- Prayer records ---

  Future<List<PrayerRecord>> getPrayerRecordsForDay(int dayRecordId) =>
      (select(prayerRecords)..where((t) => t.dayRecordId.equals(dayRecordId)))
          .get();

  Future<void> upsertPrayerRecord(PrayerRecordsCompanion record) =>
      into(prayerRecords).insertOnConflictUpdate(record);

  // --- Habit records ---

  Future<List<HabitRecord>> getHabitRecordsForDay(int dayRecordId) =>
      (select(habitRecords)..where((t) => t.dayRecordId.equals(dayRecordId)))
          .get();

  Future<void> upsertHabitRecord(HabitRecordsCompanion record) =>
      into(habitRecords).insertOnConflictUpdate(record);

  // --- Aggregates ---

  Future<List<DayRecord>> getAllDayRecords() =>
      (select(dayRecords)..orderBy([(t) => OrderingTerm.asc(t.date)])).get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'qadam.sqlite'));
    return NativeDatabase(
      file,
      setup: (rawDb) {
        rawDb.execute('PRAGMA journal_mode=WAL;');
        rawDb.execute('PRAGMA busy_timeout=5000;');
      },
    );
  });
}
