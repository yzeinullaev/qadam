import '../../shared/models/day_status.dart';

/// Prayer record snapshot for status calculation.
class PrayerSnapshot {
  const PrayerSnapshot({
    required this.prayerKey,
    required this.prayed,
    required this.qazaPrayed,
    this.prayedAt,
  });

  final String prayerKey;
  final bool prayed;
  final bool qazaPrayed;
  final DateTime? prayedAt;
}

/// Calculates day status from active prayer keys and their records.
DayStatus calculateDayStatus({
  required List<String> activePrayerKeys,
  required List<PrayerSnapshot> prayerRecords,
}) {
  if (activePrayerKeys.isEmpty) return DayStatus.empty;

  final recordMap = {
    for (final r in prayerRecords) r.prayerKey: r,
  };

  var hasAnyData = false;
  var allPrayed = true;
  var hasUnclosedMiss = false;
  var hasMiss = false;

  for (final key in activePrayerKeys) {
    final record = recordMap[key];
    if (record == null) {
      // Не отмечено — не считаем пропуском до явной отметки.
      allPrayed = false;
      continue;
    }

    hasAnyData = true;
    if (record.prayed) continue;

    hasMiss = true;
    allPrayed = false;
    if (!record.qazaPrayed) {
      hasUnclosedMiss = true;
    }
  }

  if (!hasAnyData) return DayStatus.empty;
  if (allPrayed && activePrayerKeys.every(recordMap.containsKey)) {
    return DayStatus.green;
  }
  if (hasUnclosedMiss) return DayStatus.red;
  if (hasMiss) return DayStatus.yellow;
  return DayStatus.empty;
}

WeekStatus calculateWeekStatus({
  required List<DayStatus> dayStatuses,
  required bool isFuture,
  required bool isCurrent,
}) {
  if (isFuture) return WeekStatus.future;
  if (isCurrent && dayStatuses.every((s) => s == DayStatus.empty)) {
    return WeekStatus.current;
  }

  final filled = dayStatuses.where((s) => s != DayStatus.empty).toList();
  if (filled.isEmpty) return isCurrent ? WeekStatus.current : WeekStatus.empty;

  if (filled.any((s) => s == DayStatus.red)) return WeekStatus.red;
  if (filled.any((s) => s == DayStatus.yellow)) return WeekStatus.yellow;
  if (filled.every((s) => s == DayStatus.green)) {
    return isCurrent ? WeekStatus.current : WeekStatus.green;
  }
  return WeekStatus.empty;
}
