import 'package:intl/intl.dart';

/// Life week utilities based on birth date and life expectancy.
abstract final class LifeWeekUtils {
  static int totalWeeks(int lifeExpectancy) =>
      lifeExpectancy * 52;

  /// Week index 0 = week of birth.
  static int weekIndexForDate({
    required DateTime birthDate,
    required DateTime date,
  }) {
    final birthWeekStart = _weekStart(birthDate);
    final targetWeekStart = _weekStart(date);
    return targetWeekStart.difference(birthWeekStart).inDays ~/ 7;
  }

  static DateTime weekStartForIndex({
    required DateTime birthDate,
    required int weekIndex,
  }) {
    final birthWeekStart = _weekStart(birthDate);
    return birthWeekStart.add(Duration(days: weekIndex * 7));
  }

  static DateTime weekEndForIndex({
    required DateTime birthDate,
    required int weekIndex,
  }) {
    return weekStartForIndex(birthDate: birthDate, weekIndex: weekIndex)
        .add(const Duration(days: 6));
  }

  static List<DateTime> daysInWeek({
    required DateTime birthDate,
    required int weekIndex,
  }) {
    final start = weekStartForIndex(birthDate: birthDate, weekIndex: weekIndex);
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  static int currentWeekIndex(DateTime birthDate) =>
      weekIndexForDate(birthDate: birthDate, date: DateTime.now());

  /// Год жизни (1 = первый год после рождения).
  static int lifeYearForWeekIndex(int weekIndex) => weekIndex ~/ 52 + 1;

  static int firstWeekIndexOfLifeYear(int lifeYear) => (lifeYear - 1) * 52;

  static int weekCountInLifeYear({
    required int lifeYear,
    required int totalWeeks,
  }) {
    final start = firstWeekIndexOfLifeYear(lifeYear);
    if (start >= totalWeeks) return 0;
    return (totalWeeks - start).clamp(0, 52);
  }

  static int currentLifeYear(DateTime birthDate) =>
      lifeYearForWeekIndex(currentWeekIndex(birthDate));

  static DateTime _weekStart(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return normalized.subtract(Duration(days: normalized.weekday - 1));
  }

  static String formatDate(DateTime date) =>
      DateFormat('d MMM yyyy', 'ru').format(date);

  static String formatShortDate(DateTime date) =>
      DateFormat('d MMM', 'ru').format(date);

  static String formatDayOfWeek(DateTime date) =>
      DateFormat('EEEE', 'ru').format(date);

  static String dateKey(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);

  static DateTime parseDateKey(String key) => DateTime.parse(key);
}
