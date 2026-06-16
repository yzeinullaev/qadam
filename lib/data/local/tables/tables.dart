import 'package:drift/drift.dart';

class UserProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get birthDate => dateTime()();
  IntColumn get lifeExpectancy => integer()();
  TextColumn get city => text()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  BoolColumn get useGeolocation => boolean().withDefault(const Constant(true))();
  TextColumn get calculationMethod => text()();
  TextColumn get asrMadhab => text()();
  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class PrayerSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get prayerKey => text().unique()();
  TextColumn get title => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  BoolColumn get isObligatory => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer()();
}

class HabitSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get habitKey => text().unique()();
  TextColumn get title => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer()();
  TextColumn get customTitle => text().nullable()();
}

class DayRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text().unique()();
  IntColumn get moodPercent => integer().nullable()();
  BoolColumn get quranRead => boolean().nullable()();
  BoolColumn get sadaqaDone => boolean().nullable()();
  BoolColumn get zikrDone => boolean().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class PrayerRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dayRecordId => integer().references(DayRecords, #id)();
  TextColumn get prayerKey => text()();
  BoolColumn get prayed => boolean().withDefault(const Constant(false))();
  BoolColumn get qazaPrayed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get prayedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
        {dayRecordId, prayerKey},
      ];
}

class HabitRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dayRecordId => integer().references(DayRecords, #id)();
  TextColumn get habitKey => text()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
        {dayRecordId, habitKey},
      ];
}
