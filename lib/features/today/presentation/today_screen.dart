import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/habit_keys.dart';
import '../../../core/constants/prayer_keys.dart';
import '../../../core/utils/life_progress.dart';
import '../../../core/utils/prayer_ui_helper.dart';
import '../../../data/repositories/day_record_repository.dart';
import '../../../data/repositories/prayer_time_service.dart';
import '../../../data/local/app_database.dart';
import '../../../shared/providers/database_provider.dart';
import '../../../shared/widgets/qadam_ui.dart';
import '../providers/today_day_notifier.dart';
import '../providers/today_prayer_times_notifier.dart';

/// Главный экран — Life Progress + Islamic Minimal.
class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  double _localMood = 50;
  bool _moodInitialized = false;

  TodayDayNotifier get _notifier => ref.read(todayDayNotifierProvider.notifier);

  Future<void> _refresh() async {
    await _notifier.reload();
    await ref.read(todayPrayerTimesNotifierProvider.notifier).reload();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final dayAsync = ref.watch(todayDayNotifierProvider);
    final prayerTimesAsync = ref.watch(todayPrayerTimesNotifierProvider);
    final prayerInfo = prayerTimesAsync.valueOrNull;

    return Scaffold(
      body: dayAsync.when(
        skipLoadingOnReload: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (dayData) {
          if (!_moodInitialized) {
            _localMood = (dayData.dayRecord?.moodPercent ?? 50).toDouble();
            _moodInitialized = true;
          }

          return RefreshIndicator(
            color: QadamTheme.primary,
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
              children: [
                _header(profileAsync),
                const SizedBox(height: 28),
                profileAsync.maybeWhen(
                  data: (p) => p != null
                      ? QadamLifeProgressBlock(
                          life: LifeProgress.fromProfile(p),
                          onTap: () => context.go('/life'),
                        )
                      : const SizedBox.shrink(),
                  orElse: () => const SizedBox.shrink(),
                ),
                const SizedBox(height: 28),
                _nextPrayerBlock(prayerInfo),
                const SizedBox(height: 28),
                const QadamSectionTitle('Сегодня'),
                const SizedBox(height: 8),
                _prayerRows(dayData, prayerInfo),
                const SizedBox(height: 16),
                _habitRows(dayData),
                const SizedBox(height: 8),
                _moodRow(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _header(AsyncValue<UserProfile?> profileAsync) {
    final name = profileAsync.maybeWhen(
      data: (p) => p?.name,
      orElse: () => null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstants.appName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 32,
                color: QadamTheme.primary,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          AppConstants.appSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (name != null && name.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'Ассалаумағалейкум, $name',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ],
    );
  }

  Widget _nextPrayerBlock(PrayerTimeInfo? info) {
    final nextKey = info?.nextPrayerKey;
    if (nextKey == null) {
      return Text(
        'Укажите город в настройках для времени намаза',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    final title = PrayerKeys.title(nextKey);
    final countdown = formatPrayerCountdown(info?.nextPrayerTime);

    return QadamSoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Следующий намаз',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 4),
          Text(
            countdown.isNotEmpty ? '$title $countdown' : title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: QadamTheme.primary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _prayerRows(DayData dayData, PrayerTimeInfo? info) {
    return QadamSoftCard(
      child: Column(
        children: [
          for (var i = 0; i < dayData.activePrayerKeys.length; i++)
            Builder(
              builder: (_) {
                final key = dayData.activePrayerKeys[i];
                final status = prayerUiStatus(
                  prayerKey: key,
                  dayData: dayData,
                  currentPrayerKey: info?.currentPrayerKey,
                  nextPrayerKey: info?.nextPrayerKey,
                );
                return QadamTrackingRow(
                  label: PrayerKeys.title(key),
                  glyph: prayerStatusGlyph(status),
                  subtitle: status == PrayerUiStatus.qaza ? 'Қаза' : null,
                  showDivider: i > 0,
                  onTap: () => showQadamPrayerSheet(
                    context,
                    prayerTitle: PrayerKeys.title(key),
                    onPrayed: () => _notifier.markPrayed(key),
                    onMissed: () => _notifier.markMissed(key),
                    onQaza: () => _notifier.markQaza(key),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _habitRows(DayData dayData) {
    final habits = HabitKeys.mvpActive
        .where((key) => dayData.activeHabitKeys.contains(key))
        .toList();

    return QadamSoftCard(
      child: Column(
        children: [
          for (var i = 0; i < habits.length; i++)
            Builder(
              builder: (_) {
                final key = habits[i];
                final done = dayData.habitValue(key) == true;
                final missed = dayData.habitValue(key) == false;
                final glyph = done
                    ? '✅'
                    : missed
                        ? '❌'
                        : '○';
                return QadamTrackingRow(
                  label: dayData.habitTitle(key),
                  glyph: glyph,
                  showDivider: i > 0,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    _notifier.toggleHabit(key);
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _moodRow() {
    return QadamTrackingRow(
      label: 'Настроение',
      glyph: '${moodEmoji(_localMood.round())} ${_localMood.round()}%',
      onTap: () => showQadamMoodSheet(
        context,
        initial: _localMood,
        onSaved: (v) {
          setState(() => _localMood = v.toDouble());
          _notifier.updateMood(v);
        },
      ),
    );
  }
}
