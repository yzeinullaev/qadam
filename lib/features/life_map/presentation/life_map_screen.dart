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
    final raw = DateFormat('LLL', 'ru').format(date);
    if (raw.isEmpty) return '$month';
    final trimmed = raw.replaceAll('.', '');
    return trimmed[0].toUpperCase() + trimmed.substring(1);
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
  static const _cellVisualSize = 24.0;
  static const _cellTapSize = 40.0;
  static const _cellGap = 4.0;
  static const _monthsPerRow = 3;

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
                _monthsGrid(context, months, currentMonthKey),
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

  Widget _monthsGrid(
    BuildContext context,
    List<_MonthWeeks> months,
    int currentMonthKey,
  ) {
    final rows = <Widget>[];

    for (var rowStart = 0; rowStart < months.length; rowStart += _monthsPerRow) {
      final rowEnd = (rowStart + _monthsPerRow).clamp(0, months.length);
      final rowMonths = months.sublist(rowStart, rowEnd);

      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var col = 0; col < _monthsPerRow; col++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: col == 0 ? 0 : 4,
                        right: col == _monthsPerRow - 1 ? 0 : 4,
                      ),
                      child: col < rowMonths.length
                          ? KeyedSubtree(
                              key: rowStart + col == currentMonthKey
                                  ? _currentMonthKey
                                  : null,
                              child: _monthCard(
                                context,
                                rowMonths[col],
                                rowStart + col == currentMonthKey,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _monthCard(
    BuildContext context,
    _MonthWeeks month,
    bool isCurrentMonth,
  ) {
    final borderColor = isCurrentMonth
        ? QadamTheme.primary
        : Theme.of(context).dividerColor.withValues(alpha: 0.55);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isCurrentMonth
            ? QadamTheme.primary.withValues(alpha: 0.07)
            : Theme.of(context).colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: isCurrentMonth ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              month.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isCurrentMonth ? QadamTheme.primary : null,
                  ),
            ),
            if (isCurrentMonth)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  'сейчас',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: QadamTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(
                height: 1,
                color: borderColor.withValues(alpha: isCurrentMonth ? 0.35 : 0.5),
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: _cellGap,
              runSpacing: _cellGap,
              children: month.weeks.map((week) => _weekCell(context, week)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _weekCell(BuildContext context, _WeekEntry week) {
    final isFuture = week.status == WeekStatus.future;
    final rangeEnd = week.weekStart.add(const Duration(days: 6));
    final rangeLabel =
        '${DateFormat('d MMM', 'ru').format(week.weekStart)} — '
        '${DateFormat('d MMM', 'ru').format(rangeEnd)}';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isFuture ? null : () => context.push('/week/${week.weekIndex}'),
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: _cellTapSize,
          height: _cellTapSize,
          child: Center(
            child: Tooltip(
              message: 'Неделя ${week.weekIndex + 1}\n$rangeLabel',
              child: Container(
                width: _cellVisualSize,
                height: _cellVisualSize,
                decoration: BoxDecoration(
                  color: weekStatusColor(week.status),
                  borderRadius: BorderRadius.circular(5),
                  border: week.status == WeekStatus.current
                      ? Border.all(color: QadamTheme.weekCurrent, width: 2)
                      : Border.all(
                          color: Colors.black.withValues(alpha: 0.06),
                          width: 0.5,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
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
