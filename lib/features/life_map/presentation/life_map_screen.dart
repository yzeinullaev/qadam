import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme.dart';
import '../../../core/utils/life_progress.dart';
import '../../../core/utils/life_week_utils.dart';
import '../../../shared/models/day_status.dart';
import '../../../shared/providers/database_provider.dart';
import '../../../shared/providers/repository_providers.dart';
import '../../../shared/widgets/qadam_ui.dart';
import '../../../shared/widgets/status_badge.dart';

final lifeMapProvider = FutureProvider<List<WeekStatus>>((ref) async {
  final profile = await ref.watch(userProfileProvider.future);
  if (profile == null) return [];

  return ref.watch(dayRecordRepositoryProvider).getLifeMapWeekStatuses(
        birthDate: profile.birthDate,
        lifeExpectancy: profile.lifeExpectancy,
      );
});

class _MonthWeeks {
  const _MonthWeeks({
    required this.year,
    required this.month,
    required this.weeks,
  });

  final int year;
  final int month;
  final List<_WeekEntry> weeks;

  String get title {
    final date = DateTime(year, month);
    final raw = DateFormat('LLLL', 'ru').format(date);
    if (raw.isEmpty) return '$month';
    return raw[0].toUpperCase() + raw.substring(1);
  }

  bool containsDate(DateTime date) =>
      weeks.any((w) {
        final start = w.weekStart;
        final end = start.add(const Duration(days: 6));
        return !date.isBefore(start) && !date.isAfter(end);
      });
}

class _WeekEntry {
  const _WeekEntry({
    required this.weekIndex,
    required this.status,
    required this.weekStart,
  });

  final int weekIndex;
  final WeekStatus status;
  final DateTime weekStart;
}

/// Карта жизни: календарный год, месяцы с января по декабрь.
class LifeMapScreen extends ConsumerStatefulWidget {
  const LifeMapScreen({super.key});

  @override
  ConsumerState<LifeMapScreen> createState() => _LifeMapScreenState();
}

class _LifeMapScreenState extends ConsumerState<LifeMapScreen> {
  static const _cellSize = 16.0;
  static const _cellGap = 6.0;

  final _listController = ScrollController();
  final _currentMonthKey = GlobalKey();

  int? _selectedCalendarYear;
  bool _didInitialScroll = false;

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  (int min, int max) _calendarYearRange(DateTime birthDate, int lifeExpectancy) =>
      (birthDate.year, birthDate.year + lifeExpectancy);

  /// Январь → декабрь выбранного календарного года.
  List<_MonthWeeks> _groupByCalendarYear({
    required DateTime birthDate,
    required int calendarYear,
    required List<WeekStatus> statuses,
  }) {
    final buckets = <int, List<_WeekEntry>>{
      for (var month = 1; month <= 12; month++) month: [],
    };

    for (var weekIndex = 0; weekIndex < statuses.length; weekIndex++) {
      final weekStart = LifeWeekUtils.weekStartForIndex(
        birthDate: birthDate,
        weekIndex: weekIndex,
      );
      if (weekStart.year != calendarYear) continue;

      buckets[weekStart.month]!.add(
        _WeekEntry(
          weekIndex: weekIndex,
          status: statuses[weekIndex],
          weekStart: weekStart,
        ),
      );
    }

    return [
      for (var month = 1; month <= 12; month++)
        if (buckets[month]!.isNotEmpty)
          _MonthWeeks(
            year: calendarYear,
            month: month,
            weeks: buckets[month]!,
          ),
    ];
  }

  void _scrollToCurrentMonth({
    required int calendarYear,
    required List<_MonthWeeks> months,
  }) {
    if (calendarYear != DateTime.now().year) return;
    final ctx = _currentMonthKey.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      alignment: 0.08,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final weeksAsync = ref.watch(lifeMapProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта жизни'),
      ),
      body: weeksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (statuses) {
          if (statuses.isEmpty) {
            return const Center(child: Text('Завершите onboarding'));
          }

          final profile = profileAsync.valueOrNull;
          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final birthDate = profile.birthDate;
          final (minYear, maxYear) =
              _calendarYearRange(birthDate, profile.lifeExpectancy);
          final now = DateTime.now();
          _selectedCalendarYear ??= now.year.clamp(minYear, maxYear);

          final calendarYear = _selectedCalendarYear!.clamp(minYear, maxYear);
          final months = _groupByCalendarYear(
            birthDate: birthDate,
            calendarYear: calendarYear,
            statuses: statuses,
          );

          final currentMonthKey = calendarYear == now.year
              ? months.indexWhere((m) => m.month == now.month)
              : -1;

          if (!_didInitialScroll && months.isNotEmpty && currentMonthKey >= 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _scrollToCurrentMonth(
                calendarYear: calendarYear,
                months: months,
              );
              _didInitialScroll = true;
            });
          }

          final life = LifeProgress.fromProfile(profile);
          final lifeYearAtStart = LifeWeekUtils.lifeYearForWeekIndex(
            LifeWeekUtils.weekIndexForDate(
              birthDate: birthDate,
              date: DateTime(calendarYear, 6, 15),
            ),
          );

          return ListView(
            controller: _listController,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              QadamLifeProgressBlock(life: life),
              const SizedBox(height: 20),
              _yearPager(
                calendarYear: calendarYear,
                lifeYearHint: lifeYearAtStart,
                isCurrentYear: calendarYear == now.year,
                onPrev: calendarYear > minYear
                    ? () => setState(() {
                          _selectedCalendarYear = calendarYear - 1;
                          _didInitialScroll = false;
                        })
                    : null,
                onNext: calendarYear < maxYear
                    ? () => setState(() {
                          _selectedCalendarYear = calendarYear + 1;
                          _didInitialScroll = false;
                        })
                    : null,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _legend('Хорошо', weekStatusColor(WeekStatus.green)),
                  _legend('Қаза', weekStatusColor(WeekStatus.yellow)),
                  _legend('Пропуск', weekStatusColor(WeekStatus.red)),
                  _legend('Сейчас', weekStatusColor(WeekStatus.current)),
                  _legend('Будущее', weekStatusColor(WeekStatus.future)),
                ],
              ),
              const SizedBox(height: 20),
              if (months.isEmpty)
                Text(
                  calendarYear > now.year
                      ? 'Этот год ещё в будущем'
                      : 'Нет недель в этом году',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              else
                ...months.asMap().entries.map((entry) {
                  final index = entry.key;
                  final month = entry.value;
                  final isCurrentMonth = index == currentMonthKey;

                  return KeyedSubtree(
                    key: isCurrentMonth ? _currentMonthKey : null,
                    child: _monthSection(context, month, isCurrentMonth),
                  );
                }),
            ],
          );
        },
      ),
    );
  }

  Widget _yearPager({
    required int calendarYear,
    required int lifeYearHint,
    required bool isCurrentYear,
    required VoidCallback? onPrev,
    required VoidCallback? onNext,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onPrev,
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Предыдущий год',
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '$calendarYear',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '≈ $lifeYearHint-й год жизни',
                    style: Theme.of(context).textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (isCurrentYear)
                    Text(
                      'Сейчас',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: QadamTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                ],
              ),
            ),
            IconButton(
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Следующий год',
            ),
          ],
        ),
      ],
    );
  }

  Widget _monthSection(
    BuildContext context,
    _MonthWeeks month,
    bool isCurrentMonth,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                month.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isCurrentMonth ? QadamTheme.primary : null,
                    ),
              ),
              if (isCurrentMonth) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: QadamTheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'сейчас',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: QadamTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                '${month.weeks.length} нед.',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: 10),
          QadamSoftCard(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: _cellGap,
              runSpacing: _cellGap,
              children: month.weeks.map((week) {
                return _weekCell(context, week);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _weekCell(BuildContext context, _WeekEntry week) {
    final isFuture = week.status == WeekStatus.future;
    final rangeEnd = week.weekStart.add(const Duration(days: 6));
    final rangeLabel =
        '${DateFormat('d MMM', 'ru').format(week.weekStart)} — '
        '${DateFormat('d MMM', 'ru').format(rangeEnd)}';

    return GestureDetector(
      onTap: isFuture
          ? null
          : () => context.push('/week/${week.weekIndex}'),
      child: Tooltip(
        message: 'Неделя ${week.weekIndex + 1}\n$rangeLabel',
        child: Container(
          width: _cellSize,
          height: _cellSize,
          decoration: BoxDecoration(
            color: weekStatusColor(week.status),
            borderRadius: BorderRadius.circular(4),
            border: week.status == WeekStatus.current
                ? Border.all(color: QadamTheme.weekCurrent, width: 1.5)
                : null,
          ),
        ),
      ),
    );
  }

  Widget _legend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
