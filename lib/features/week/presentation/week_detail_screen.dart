import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/life_week_utils.dart';
import '../../../data/repositories/day_record_repository.dart';
import '../../../shared/providers/database_provider.dart';
import '../../../shared/providers/repository_providers.dart';
import '../../../shared/widgets/qadam_ui.dart';
import '../../../shared/widgets/status_badge.dart';

final weekDataProvider =
    FutureProvider.family<List<DayData>, int>((ref, weekIndex) async {
  final profile = await ref.watch(userProfileProvider.future);
  if (profile == null) return [];
  return ref.watch(dayRecordRepositoryProvider).getWeekData(
        birthDate: profile.birthDate,
        weekIndex: weekIndex,
      );
});

class WeekDetailScreen extends ConsumerWidget {
  const WeekDetailScreen({super.key, required this.weekIndex});

  final int weekIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final weekAsync = ref.watch(weekDataProvider(weekIndex));

    return Scaffold(
      appBar: AppBar(title: Text('Неделя ${weekIndex + 1}')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Профиль не найден'));
          }

          final start = LifeWeekUtils.weekStartForIndex(
            birthDate: profile.birthDate,
            weekIndex: weekIndex,
          );
          final end = LifeWeekUtils.weekEndForIndex(
            birthDate: profile.birthDate,
            weekIndex: weekIndex,
          );

          return weekAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Ошибка: $e')),
            data: (days) {
              final stats = _computeWeekStats(days);

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  Text(
                    '${LifeWeekUtils.formatShortDate(start)} — ${LifeWeekUtils.formatShortDate(end)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  QadamWeekSummary(
                    prayersDone: stats.completedPrayers,
                    prayersTotal: stats.totalPrayers,
                    quranDays: stats.quranDays,
                    sadaqaDays: stats.sadaqaDays,
                    avgMood: stats.avgMood.round(),
                  ),
                  const SizedBox(height: 20),
                  const QadamSectionTitle('Дни'),
                  const SizedBox(height: 8),
                  ...days.map((day) => _dayTile(context, day)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  _WeekStats _computeWeekStats(List<DayData> days) {
    var totalPrayers = 0;
    var completedPrayers = 0;
    var quranDays = 0;
    var sadaqaDays = 0;
    var moodSum = 0;
    var moodCount = 0;

    for (final day in days) {
      totalPrayers += day.totalActivePrayers;
      completedPrayers += day.completedPrayers;
      if (day.dayRecord?.quranRead == true) quranDays++;
      if (day.dayRecord?.sadaqaDone == true) sadaqaDays++;
      if (day.dayRecord?.moodPercent != null) {
        moodSum += day.dayRecord!.moodPercent!;
        moodCount++;
      }
    }

    return _WeekStats(
      totalPrayers: totalPrayers,
      completedPrayers: completedPrayers,
      quranDays: quranDays,
      sadaqaDays: sadaqaDays,
      avgMood: moodCount > 0 ? moodSum / moodCount : 0,
    );
  }

  Widget _dayTile(BuildContext context, DayData day) {
    final prayed = day.completedPrayers;
    final total = day.totalActivePrayers;
    final mood = day.dayRecord?.moodPercent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: QadamSoftCard(
        child: InkWell(
          onTap: () => context.push('/day/${LifeWeekUtils.dateKey(day.date)}'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LifeWeekUtils.formatShortDate(day.date),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        'Намаз $prayed/$total'
                        '${mood != null ? ' · $mood%' : ''}',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: day.status),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WeekStats {
  const _WeekStats({
    required this.totalPrayers,
    required this.completedPrayers,
    required this.quranDays,
    required this.sadaqaDays,
    required this.avgMood,
  });

  final int totalPrayers;
  final int completedPrayers;
  final int quranDays;
  final int sadaqaDays;
  final double avgMood;
}
