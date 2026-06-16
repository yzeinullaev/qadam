import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/habit_keys.dart';
import '../../../core/constants/prayer_keys.dart';
import '../../../core/utils/life_week_utils.dart';
import '../../../core/utils/prayer_ui_helper.dart';
import '../../../shared/widgets/qadam_ui.dart';
import '../../../shared/widgets/status_badge.dart';
import '../providers/day_detail_notifier.dart';

class DayDetailScreen extends ConsumerStatefulWidget {
  const DayDetailScreen({super.key, required this.dateKey});

  final String dateKey;

  @override
  ConsumerState<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends ConsumerState<DayDetailScreen> {
  double _localMood = 50;
  bool _moodInitialized = false;

  @override
  Widget build(BuildContext context) {
    final dayAsync = ref.watch(dayDetailNotifierProvider(widget.dateKey));
    final notifier =
        ref.read(dayDetailNotifierProvider(widget.dateKey).notifier);
    final date = LifeWeekUtils.parseDateKey(widget.dateKey);

    return Scaffold(
      appBar: AppBar(
        title: Text(LifeWeekUtils.formatDate(date)),
      ),
      body: dayAsync.when(
        skipLoadingOnReload: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (day) {
          if (!_moodInitialized) {
            _localMood = (day.dayRecord?.moodPercent ?? 50).toDouble();
            _moodInitialized = true;
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              StatusBadge(status: day.status),
              const SizedBox(height: 20),
              const QadamSectionTitle('Намазы'),
              const SizedBox(height: 8),
              QadamSoftCard(
                child: Column(
                  children: [
                    for (var i = 0; i < day.activePrayerKeys.length; i++)
                      Builder(
                        builder: (_) {
                          final key = day.activePrayerKeys[i];
                          final record = day.prayerRecords
                              .where((r) => r.prayerKey == key)
                              .firstOrNull;
                          final status = prayerRecordUiStatus(record);
                          return QadamTrackingRow(
                            label: PrayerKeys.title(key),
                            glyph: prayerStatusGlyph(status),
                            subtitle: status == PrayerUiStatus.qaza
                                ? 'Қаза'
                                : null,
                            showDivider: i > 0,
                            onTap: () => showQadamPrayerSheet(
                              context,
                              prayerTitle: PrayerKeys.title(key),
                              onPrayed: () => notifier.markPrayed(key),
                              onMissed: () => notifier.markMissed(key),
                              onQaza: () => notifier.markQaza(key),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const QadamSectionTitle('Привычки'),
              const SizedBox(height: 8),
              QadamSoftCard(
                child: Column(
                  children: [
                    for (var i = 0;
                        i <
                            day.activeHabitKeys
                                .where(HabitKeys.mvpActive.contains)
                                .length;
                        i++)
                      Builder(
                        builder: (_) {
                          final habits = day.activeHabitKeys
                              .where(HabitKeys.mvpActive.contains)
                              .toList();
                          final key = habits[i];
                          final done = day.habitValue(key) == true;
                          final missed = day.habitValue(key) == false;
                          final glyph = done
                              ? '✅'
                              : missed
                                  ? '❌'
                                  : '○';
                          return QadamTrackingRow(
                            label: day.habitTitle(key),
                            glyph: glyph,
                            showDivider: i > 0,
                            onTap: () {
                              HapticFeedback.selectionClick();
                              notifier.toggleHabit(key);
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              QadamTrackingRow(
                label: 'Настроение',
                glyph:
                    '${moodEmoji(_localMood.round())} ${_localMood.round()}%',
                onTap: () => showQadamMoodSheet(
                  context,
                  initial: _localMood,
                  onSaved: (v) {
                    setState(() => _localMood = v.toDouble());
                    notifier.updateMood(v);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (it.moveNext()) return it.current;
    return null;
  }
}
