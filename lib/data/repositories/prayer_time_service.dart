import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../local/app_database.dart';
import '../../core/constants/prayer_keys.dart';
import '../../shared/providers/database_provider.dart';

class PrayerTimeInfo {
  const PrayerTimeInfo({
    required this.currentPrayerKey,
    required this.nextPrayerKey,
    required this.nextPrayerTime,
    required this.allTimes,
  });

  final String? currentPrayerKey;
  final String? nextPrayerKey;
  final DateTime? nextPrayerTime;
  final Map<String, DateTime> allTimes;
}

String? _prayerKeyFromEnum(Prayer prayer) {
  return switch (prayer) {
    Prayer.fajr || Prayer.fajrAfter => PrayerKeys.fajr,
    Prayer.dhuhr => PrayerKeys.dhuhr,
    Prayer.asr => PrayerKeys.asr,
    Prayer.maghrib => PrayerKeys.maghrib,
    Prayer.isha || Prayer.ishaBefore => PrayerKeys.isha,
    _ => null,
  };
}

class PrayerTimeService {
  PrayerTimeService(this._db);

  final AppDatabase _db;

  CalculationParameters _paramsFromProfile(UserProfile profile) {
    final params = switch (profile.calculationMethod) {
      'Turkey' => CalculationMethodParameters.turkiye(),
      'Umm al-Qura' => CalculationMethodParameters.ummAlQura(),
      'Custom' => CalculationMethodParameters.other(),
      _ => CalculationMethodParameters.muslimWorldLeague(),
    };
    params.madhab =
        profile.asrMadhab == 'Hanafi' ? Madhab.hanafi : Madhab.shafi;
    return params;
  }

  Future<PrayerTimeInfo?> getTodayPrayerTimes() async {
    final profile = await _db.getUserProfile();
    if (profile == null) return null;

    final lat = profile.latitude;
    final lng = profile.longitude;
    if (lat == null || lng == null) return null;

    final coordinates = Coordinates(lat, lng);
    final params = _paramsFromProfile(profile);
    final now = DateTime.now();
    final prayerTimes = PrayerTimes(
      coordinates: coordinates,
      date: now,
      calculationParameters: params,
      precision: true,
    );

    final times = <String, DateTime>{
      PrayerKeys.fajr: prayerTimes.fajr.toLocal(),
      PrayerKeys.dhuhr: prayerTimes.dhuhr.toLocal(),
      PrayerKeys.asr: prayerTimes.asr.toLocal(),
      PrayerKeys.maghrib: prayerTimes.maghrib.toLocal(),
      PrayerKeys.isha: prayerTimes.isha.toLocal(),
    };

    final active = await _db.getActivePrayerSettings();
    final activeKeys =
        active.map((p) => p.prayerKey).where(times.containsKey).toList();

    final currentPrayer = prayerTimes.currentPrayer(date: now);
    final nextPrayer = prayerTimes.nextPrayer(date: now);
    final currentKey = _prayerKeyFromEnum(currentPrayer);
    final nextKey = _prayerKeyFromEnum(nextPrayer);
    final nextTime = prayerTimes.timeForPrayer(nextPrayer).toLocal();

    return PrayerTimeInfo(
      currentPrayerKey:
          currentKey != null && activeKeys.contains(currentKey) ? currentKey : null,
      nextPrayerKey:
          nextKey != null && activeKeys.contains(nextKey) ? nextKey : null,
      nextPrayerTime: nextTime,
      allTimes: times,
    );
  }
}

final prayerTimeServiceProvider = Provider<PrayerTimeService>((ref) {
  return PrayerTimeService(ref.watch(databaseProvider));
});
