import 'package:flutter_test/flutter_test.dart';
import 'package:qadam/core/constants/prayer_keys.dart';
import 'package:qadam/core/utils/day_status_calculator.dart';
import 'package:qadam/core/utils/life_week_utils.dart';
import 'package:qadam/core/utils/score_calculator.dart';
import 'package:qadam/shared/models/day_status.dart';

void main() {
  group('Day status', () {
    test('green when all active prayers completed', () {
      final status = calculateDayStatus(
        activePrayerKeys: PrayerKeys.defaultActive,
        prayerRecords: PrayerKeys.defaultActive
            .map(
              (k) => PrayerSnapshot(
                prayerKey: k,
                prayed: true,
                qazaPrayed: false,
              ),
            )
            .toList(),
      );
      expect(status, DayStatus.green);
    });

    test('yellow when miss but qaza closed', () {
      final status = calculateDayStatus(
        activePrayerKeys: ['fajr', 'dhuhr'],
        prayerRecords: const [
          PrayerSnapshot(
            prayerKey: 'fajr',
            prayed: false,
            qazaPrayed: true,
          ),
          PrayerSnapshot(
            prayerKey: 'dhuhr',
            prayed: true,
            qazaPrayed: false,
          ),
        ],
      );
      expect(status, DayStatus.yellow);
    });

    test('red when miss without qaza', () {
      final status = calculateDayStatus(
        activePrayerKeys: ['fajr'],
        prayerRecords: const [
          PrayerSnapshot(
            prayerKey: 'fajr',
            prayed: false,
            qazaPrayed: false,
          ),
        ],
      );
      expect(status, DayStatus.red);
    });

    test('empty when no records', () {
      final status = calculateDayStatus(
        activePrayerKeys: ['fajr'],
        prayerRecords: const [],
      );
      expect(status, DayStatus.empty);
    });

    test('unmarked prayers do not make day red', () {
      final status = calculateDayStatus(
        activePrayerKeys: ['fajr', 'dhuhr'],
        prayerRecords: const [
          PrayerSnapshot(
            prayerKey: 'fajr',
            prayed: true,
            qazaPrayed: false,
          ),
        ],
      );
      expect(status, DayStatus.empty);
    });

    test('green requires all prayers marked and prayed', () {
      final status = calculateDayStatus(
        activePrayerKeys: ['fajr', 'dhuhr'],
        prayerRecords: const [
          PrayerSnapshot(
            prayerKey: 'fajr',
            prayed: true,
            qazaPrayed: false,
          ),
          PrayerSnapshot(
            prayerKey: 'dhuhr',
            prayed: true,
            qazaPrayed: false,
          ),
        ],
      );
      expect(status, DayStatus.green);
    });
  });

  group('Week status', () {
    test('red week if any red day', () {
      expect(
        calculateWeekStatus(
          dayStatuses: [DayStatus.green, DayStatus.red],
          isFuture: false,
          isCurrent: false,
        ),
        WeekStatus.red,
      );
    });

    test('current week with no data stays current', () {
      expect(
        calculateWeekStatus(
          dayStatuses: List.filled(7, DayStatus.empty),
          isFuture: false,
          isCurrent: true,
        ),
        WeekStatus.current,
      );
    });
  });

  group('Scores', () {
    test('completion score respects active prayers only', () {
      expect(
        calculateCompletionScore(
          completedActivePrayers: 1,
          totalActivePrayers: 1,
        ),
        100,
      );
      expect(
        calculateCompletionScore(
          completedActivePrayers: 4,
          totalActivePrayers: 5,
        ),
        80,
      );
    });

    test('bereke score max 100', () {
      final score = calculateBerekeScore(
        completedActivePrayers: 5,
        totalActivePrayers: 5,
        missedWithQazaClosed: 0,
        totalMissed: 0,
        quranDone: true,
        quranActive: true,
        sadaqaDone: true,
        sadaqaActive: true,
        completedHabits: 3,
        totalActiveHabits: 3,
      );
      expect(score, 100);
    });
  });

  group('Life weeks', () {
    test('total weeks = expectancy * 52', () {
      expect(LifeWeekUtils.totalWeeks(80), 4160);
    });

    test('week index increases with age', () {
      final birth = DateTime(1990, 1, 1);
      final week0 = LifeWeekUtils.weekIndexForDate(
        birthDate: birth,
        date: DateTime(1990, 1, 3),
      );
      final week100 = LifeWeekUtils.weekIndexForDate(
        birthDate: birth,
        date: birth.add(const Duration(days: 700)),
      );
      expect(week100, greaterThan(week0));
    });

    test('life year from week index', () {
      expect(LifeWeekUtils.lifeYearForWeekIndex(0), 1);
      expect(LifeWeekUtils.lifeYearForWeekIndex(51), 1);
      expect(LifeWeekUtils.lifeYearForWeekIndex(52), 2);
    });

    test('week count in life year respects total', () {
      expect(
        LifeWeekUtils.weekCountInLifeYear(lifeYear: 1, totalWeeks: 100),
        52,
      );
      expect(
        LifeWeekUtils.weekCountInLifeYear(lifeYear: 2, totalWeeks: 100),
        48,
      );
    });
  });
}
