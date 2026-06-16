import 'package:drift/drift.dart';

import '../local/app_database.dart';

class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  Future<UserProfile?> getProfile() => _db.getUserProfile();

  Future<void> updateProfile(UserProfilesCompanion profile) =>
      _db.updateUserProfile(profile);

  Future<List<PrayerSetting>> getPrayerSettings() =>
      _db.getAllPrayerSettings();

  Future<List<HabitSetting>> getHabitSettings() => _db.getAllHabitSettings();

  Future<void> setPrayerActive(String prayerKey, bool isActive) async {
    final settings = await _db.getAllPrayerSettings();
    final setting = settings.firstWhere((s) => s.prayerKey == prayerKey);
    await _db.upsertPrayerSetting(
      PrayerSettingsCompanion(
        id: Value(setting.id),
        prayerKey: Value(setting.prayerKey),
        title: Value(setting.title),
        isActive: Value(isActive),
        isObligatory: Value(setting.isObligatory),
        sortOrder: Value(setting.sortOrder),
      ),
    );
  }

  Future<void> setHabitActive(String habitKey, bool isActive) async {
    final settings = await _db.getAllHabitSettings();
    final setting = settings.firstWhere((s) => s.habitKey == habitKey);
    await _db.upsertHabitSetting(
      HabitSettingsCompanion(
        id: Value(setting.id),
        habitKey: Value(setting.habitKey),
        title: Value(setting.title),
        isActive: Value(isActive),
        sortOrder: Value(setting.sortOrder),
        customTitle: Value(setting.customTitle),
      ),
    );
  }

  Future<void> setCustomHabitTitle(String title) async {
    final settings = await _db.getAllHabitSettings();
    final setting = settings.firstWhere((s) => s.habitKey == 'custom');
    await _db.upsertHabitSetting(
      HabitSettingsCompanion(
        id: Value(setting.id),
        habitKey: Value(setting.habitKey),
        title: Value(setting.title),
        isActive: Value(setting.isActive),
        sortOrder: Value(setting.sortOrder),
        customTitle: Value(title),
      ),
    );
  }
}
