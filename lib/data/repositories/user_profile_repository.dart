import 'package:drift/drift.dart';

import '../local/app_database.dart';
import '../../core/constants/habit_keys.dart';
import '../../core/constants/prayer_keys.dart';
import '../../core/utils/city_coordinates.dart';

class UserProfileRepository {
  UserProfileRepository(this._db);

  final AppDatabase _db;

  Future<UserProfile?> getProfile() => _db.getUserProfile();

  Future<bool> isOnboardingCompleted() async {
    final profile = await _db.getUserProfile();
    return profile?.onboardingCompleted ?? false;
  }

  Future<void> saveProfile({
    required String name,
    required DateTime birthDate,
    required int lifeExpectancy,
    required String city,
    double? latitude,
    double? longitude,
    required bool useGeolocation,
    required String calculationMethod,
    required String asrMadhab,
    required bool onboardingCompleted,
    required List<String> activePrayerKeys,
    required List<String> activeHabitKeys,
    String? customHabitTitle,
  }) async {
    final now = DateTime.now();
    final existing = await _db.getUserProfile();

    var resolvedLat = latitude;
    var resolvedLng = longitude;
    if (!useGeolocation || resolvedLat == null || resolvedLng == null) {
      final coords = CityCoordinates.forCity(city);
      resolvedLat = coords.$1;
      resolvedLng = coords.$2;
    }

    if (existing == null) {
      await _db.insertUserProfile(
        UserProfilesCompanion.insert(
          name: name,
          birthDate: birthDate,
          lifeExpectancy: lifeExpectancy,
          city: city,
          latitude: Value(resolvedLat),
          longitude: Value(resolvedLng),
          useGeolocation: Value(useGeolocation),
          calculationMethod: calculationMethod,
          asrMadhab: asrMadhab,
          onboardingCompleted: Value(onboardingCompleted),
          createdAt: now,
          updatedAt: now,
        ),
      );
    } else {
      await _db.updateUserProfile(
        UserProfilesCompanion(
          id: Value(existing.id),
          name: Value(name),
          birthDate: Value(birthDate),
          lifeExpectancy: Value(lifeExpectancy),
          city: Value(city),
          latitude: Value(resolvedLat),
          longitude: Value(resolvedLng),
          useGeolocation: Value(useGeolocation),
          calculationMethod: Value(calculationMethod),
          asrMadhab: Value(asrMadhab),
          onboardingCompleted: Value(onboardingCompleted),
          updatedAt: Value(now),
        ),
      );
    }

    await _seedDefaultSettingsIfNeeded();
    await _syncActivePrayers(activePrayerKeys);
    await _syncActiveHabits(activeHabitKeys, customHabitTitle);
  }

  Future<void> _seedDefaultSettingsIfNeeded() async {
    final prayers = await _db.getAllPrayerSettings();
    if (prayers.isEmpty) {
      for (var i = 0; i < PrayerKeys.all.length; i++) {
        final key = PrayerKeys.all[i];
        await _db.upsertPrayerSetting(
          PrayerSettingsCompanion.insert(
            prayerKey: key,
            title: PrayerKeys.title(key),
            isActive: Value(PrayerKeys.defaultActive.contains(key)),
            isObligatory: Value(PrayerKeys.obligatory.contains(key)),
            sortOrder: i,
          ),
        );
      }
    }

    final habits = await _db.getAllHabitSettings();
    if (habits.isEmpty) {
      for (var i = 0; i < HabitKeys.all.length; i++) {
        final key = HabitKeys.all[i];
        await _db.upsertHabitSetting(
          HabitSettingsCompanion.insert(
            habitKey: key,
            title: HabitKeys.title(key),
            isActive: Value(HabitKeys.defaultActive.contains(key)),
            sortOrder: i,
          ),
        );
      }
    }
  }

  Future<void> _syncActivePrayers(List<String> activeKeys) async {
    final all = await _db.getAllPrayerSettings();
    for (final setting in all) {
      await _db.upsertPrayerSetting(
        PrayerSettingsCompanion(
          id: Value(setting.id),
          prayerKey: Value(setting.prayerKey),
          title: Value(setting.title),
          isActive: Value(activeKeys.contains(setting.prayerKey)),
          isObligatory: Value(setting.isObligatory),
          sortOrder: Value(setting.sortOrder),
        ),
      );
    }
  }

  Future<void> _syncActiveHabits(
    List<String> activeKeys,
    String? customTitle,
  ) async {
    final all = await _db.getAllHabitSettings();
    for (final setting in all) {
      await _db.upsertHabitSetting(
        HabitSettingsCompanion(
          id: Value(setting.id),
          habitKey: Value(setting.habitKey),
          title: Value(setting.title),
          isActive: Value(activeKeys.contains(setting.habitKey)),
          sortOrder: Value(setting.sortOrder),
          customTitle: setting.habitKey == HabitKeys.custom
              ? Value(customTitle)
              : const Value.absent(),
        ),
      );
    }
  }
}
