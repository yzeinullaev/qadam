/// Canonical habit keys.
abstract final class HabitKeys {
  static const quran = 'quran';
  static const sadaqa = 'sadaqa';
  static const zikr = 'zikr';
  static const sport = 'sport';
  static const family = 'family';
  static const custom = 'custom';

  static const all = [quran, sadaqa, zikr, sport, family, custom];

  static const defaultActive = [quran, sadaqa];

  /// Привычки, видимые в MVP.
  static const mvpActive = [quran, sadaqa];

  static const titles = {
    quran: 'Коран',
    sadaqa: 'Садака',
    zikr: 'Зикр',
    sport: 'Спорт',
    family: 'Семья',
    custom: 'Своя привычка',
  };

  static String title(String key) => titles[key] ?? key;
}
