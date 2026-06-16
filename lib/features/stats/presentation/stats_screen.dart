import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/constants/app_strings.dart';
import '../../../data/repositories/day_record_repository.dart';
import '../../../features/life_map/presentation/life_map_screen.dart';
import '../../../shared/models/day_status.dart';
import '../../../shared/providers/database_provider.dart';
import '../../../shared/providers/repository_providers.dart';

class StatsSummary {
  const StatsSummary({
    required this.moodOnPlanDays,
    required this.moodOnMissDays,
    required this.greenWeeks,
    required this.yellowWeeks,
    required this.redWeeks,
    required this.quranThisMonth,
    required this.sadaqaThisMonth,
    required this.prayerStreak,
    required this.quranStreak,
    required this.insight,
  });

  final double moodOnPlanDays;
  final double moodOnMissDays;
  final int greenWeeks;
  final int yellowWeeks;
  final int redWeeks;
  final int quranThisMonth;
  final int sadaqaThisMonth;
  final int prayerStreak;
  final int quranStreak;
  final String insight;
}

final statsSummaryProvider = FutureProvider<StatsSummary>((ref) async {
  final profile = await ref.watch(userProfileProvider.future);
  if (profile == null) {
    return const StatsSummary(
      moodOnPlanDays: 0,
      moodOnMissDays: 0,
      greenWeeks: 0,
      yellowWeeks: 0,
      redWeeks: 0,
      quranThisMonth: 0,
      sadaqaThisMonth: 0,
      prayerStreak: 0,
      quranStreak: 0,
      insight: 'Завершите onboarding',
    );
  }

  final allDays = await ref.watch(dayRecordRepositoryProvider).getAllDayData();

  if (allDays.isEmpty) {
    return const StatsSummary(
      moodOnPlanDays: 0,
      moodOnMissDays: 0,
      greenWeeks: 0,
      yellowWeeks: 0,
      redWeeks: 0,
      quranThisMonth: 0,
      sadaqaThisMonth: 0,
      prayerStreak: 0,
      quranStreak: 0,
      insight: AppStrings.statsEmptyHint,
    );
  }

  final weekStatuses = await ref.watch(lifeMapProvider.future);

  var moodPlanSum = 0;
  var moodPlanCount = 0;
  var moodMissSum = 0;
  var moodMissCount = 0;

  final now = DateTime.now();
  final monthStart = DateTime(now.year, now.month, 1);
  var quranMonth = 0;
  var sadaqaMonth = 0;

  for (final day in allDays) {
    if (day.dayRecord?.moodPercent != null) {
      if (day.status == DayStatus.green) {
        moodPlanSum += day.dayRecord!.moodPercent!;
        moodPlanCount++;
      } else if (day.status == DayStatus.red || day.status == DayStatus.yellow) {
        moodMissSum += day.dayRecord!.moodPercent!;
        moodMissCount++;
      }
    }

    if (!day.date.isBefore(monthStart)) {
      if (day.dayRecord?.quranRead == true) quranMonth++;
      if (day.dayRecord?.sadaqaDone == true) sadaqaMonth++;
    }
  }

  final moodPlan =
      moodPlanCount > 0 ? moodPlanSum / moodPlanCount : 0.0;
  final moodMiss =
      moodMissCount > 0 ? moodMissSum / moodMissCount : 0.0;

  final greenWeeks = weekStatuses.where((s) => s == WeekStatus.green).length;
  final yellowWeeks = weekStatuses.where((s) => s == WeekStatus.yellow).length;
  final redWeeks = weekStatuses.where((s) => s == WeekStatus.red).length;

  final prayerStreak = _calculatePrayerStreak(allDays);
  final quranStreak = _calculateQuranStreak(allDays);

  final insight = moodPlanCount > 0 && moodMissCount > 0
      ? 'В дни, когда ты выполнил план намаза, среднее настроение было ${moodPlan.round()}%.\n'
          'В дни с пропусками — ${moodMiss.round()}%.'
      : AppStrings.statsEmptyHint;

  return StatsSummary(
    moodOnPlanDays: moodPlan,
    moodOnMissDays: moodMiss,
    greenWeeks: greenWeeks,
    yellowWeeks: yellowWeeks,
    redWeeks: redWeeks,
    quranThisMonth: quranMonth,
    sadaqaThisMonth: sadaqaMonth,
    prayerStreak: prayerStreak,
    quranStreak: quranStreak,
    insight: insight,
  );
});

int _calculatePrayerStreak(List<DayData> days) {
  final sorted = [...days]..sort((a, b) => b.date.compareTo(a.date));
  var streak = 0;
  var expected = DateTime.now();
  expected = DateTime(expected.year, expected.month, expected.day);

  for (final day in sorted) {
    final d = DateTime(day.date.year, day.date.month, day.date.day);
    if (d.isAfter(expected)) continue;
    if (d.isBefore(expected)) break;
    if (day.status == DayStatus.green) {
      streak++;
      expected = expected.subtract(const Duration(days: 1));
    } else if (day.status != DayStatus.empty) {
      break;
    } else {
      expected = expected.subtract(const Duration(days: 1));
    }
  }
  return streak;
}

int _calculateQuranStreak(List<DayData> days) {
  final sorted = [...days]..sort((a, b) => b.date.compareTo(a.date));
  var streak = 0;
  var expected = DateTime.now();
  expected = DateTime(expected.year, expected.month, expected.day);

  for (final day in sorted) {
    final d = DateTime(day.date.year, day.date.month, day.date.day);
    if (d.isAfter(expected)) continue;
    if (d.isBefore(expected)) break;
    if (day.dayRecord?.quranRead == true) {
      streak++;
      expected = expected.subtract(const Duration(days: 1));
    } else if (day.dayRecord != null) {
      break;
    } else {
      expected = expected.subtract(const Duration(days: 1));
    }
  }
  return streak;
}

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statsSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navStats)),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (stats) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  stats.insight,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _moodChart(context, stats),
            const SizedBox(height: 16),
            _statGrid(context, stats),
          ],
        ),
      ),
    );
  }

  Widget _moodChart(BuildContext context, StatsSummary stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Настроение и план',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  maxY: 100,
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: stats.moodOnPlanDays,
                          color: Colors.green,
                          width: 32,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: stats.moodOnMissDays,
                          color: Colors.orange,
                          width: 32,
                        ),
                      ],
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          return Text(
                            value == 0 ? 'План' : 'Пропуски',
                            style: const TextStyle(fontSize: 11),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (v, _) =>
                            Text('${v.toInt()}', style: const TextStyle(fontSize: 10)),
                      ),
                    ),
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statGrid(BuildContext context, StatsSummary stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _statCard(context, 'Зелёные недели', '${stats.greenWeeks}'),
        _statCard(context, 'Жёлтые недели', '${stats.yellowWeeks}'),
        _statCard(context, 'Красные недели', '${stats.redWeeks}'),
        _statCard(context, 'Коран (месяц)', '${stats.quranThisMonth}'),
        _statCard(context, 'Садака (месяц)', '${stats.sadaqaThisMonth}'),
        _statCard(context, 'Streak намаз', '${stats.prayerStreak}'),
        _statCard(context, 'Streak Коран', '${stats.quranStreak}'),
      ],
    );
  }

  Widget _statCard(BuildContext context, String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}
