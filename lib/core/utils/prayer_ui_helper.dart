import '../../data/local/app_database.dart';
import '../../data/repositories/day_record_repository.dart';

enum PrayerUiStatus { done, qaza, current, missed, pending }

PrayerUiStatus prayerUiStatus({
  required String prayerKey,
  required DayData dayData,
  String? currentPrayerKey,
  String? nextPrayerKey,
}) {
  final record =
      dayData.prayerRecords.where((r) => r.prayerKey == prayerKey).firstOrNull;

  if (record?.prayed == true) return PrayerUiStatus.done;
  if (record?.qazaPrayed == true) return PrayerUiStatus.qaza;
  if (record != null && record.prayed == false && !record.qazaPrayed) {
    return PrayerUiStatus.missed;
  }
  if (prayerKey == currentPrayerKey || prayerKey == nextPrayerKey) {
    return PrayerUiStatus.current;
  }
  return PrayerUiStatus.pending;
}

PrayerUiStatus prayerRecordUiStatus(PrayerRecord? record) {
  if (record == null) return PrayerUiStatus.pending;
  if (record.prayed) return PrayerUiStatus.done;
  if (record.qazaPrayed) return PrayerUiStatus.qaza;
  if (!record.prayed && !record.qazaPrayed) return PrayerUiStatus.missed;
  return PrayerUiStatus.pending;
}

String prayerStatusGlyph(PrayerUiStatus status) {
  return switch (status) {
    PrayerUiStatus.done => '✅',
    PrayerUiStatus.qaza => '🕌',
    PrayerUiStatus.current => '⏳',
    PrayerUiStatus.missed => '✗',
    PrayerUiStatus.pending => '○',
  };
}

String formatPrayerCountdown(DateTime? target) {
  if (target == null) return '';
  final diff = target.difference(DateTime.now());
  if (diff.isNegative) return 'скоро';
  final hours = diff.inHours;
  final minutes = diff.inMinutes % 60;
  if (hours > 0) return 'через $hoursч $minutesм';
  if (minutes > 0) return 'через $minutesм';
  return 'скоро';
}

String moodEmoji(int percent) {
  if (percent >= 80) return '😊';
  if (percent >= 60) return '🙂';
  if (percent >= 40) return '😐';
  if (percent >= 20) return '😔';
  return '😞';
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (it.moveNext()) return it.current;
    return null;
  }
}
