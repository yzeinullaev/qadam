/// Canonical prayer keys used in DB and business logic.
abstract final class PrayerKeys {
  static const fajr = 'fajr';
  static const dhuhr = 'dhuhr';
  static const asr = 'asr';
  static const maghrib = 'maghrib';
  static const isha = 'isha';
  static const tahajjud = 'tahajjud';
  static const duha = 'duha';
  static const witr = 'witr';
  static const sunnahFajr = 'sunnah_fajr';
  static const sunnahDhuhrAfter = 'sunnah_dhuhr_after';

  static const all = [
    fajr,
    dhuhr,
    asr,
    maghrib,
    isha,
    tahajjud,
    duha,
    witr,
    sunnahFajr,
    sunnahDhuhrAfter,
  ];

  static const defaultActive = [fajr, dhuhr, asr, maghrib, isha];

  static const titles = {
    fajr: 'Фаджр',
    dhuhr: 'Зухр',
    asr: 'Аср',
    maghrib: 'Магриб',
    isha: 'Иша',
    tahajjud: 'Тахаджуд',
    duha: 'Духа',
    witr: 'Витр',
    sunnahFajr: 'Сунна Фаджр',
    sunnahDhuhrAfter: 'Сунна после Зухр',
  };

  static const obligatory = {fajr, dhuhr, asr, maghrib, isha};

  static String title(String key) => titles[key] ?? key;
}
