import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import '../../core/utils/life_progress.dart';

/// Общие виджеты: Life Progress + Islamic Minimal + GitHub-акценты.
class QadamSectionTitle extends StatelessWidget {
  const QadamSectionTitle(this.title, {super.key, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                ),
          ),
          if (subtitle != null)
            Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class QadamSoftCard extends StatelessWidget {
  const QadamSoftCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: QadamTheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFEDEAE3)),
      ),
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    );
  }
}

class QadamTrackingRow extends StatelessWidget {
  const QadamTrackingRow({
    super.key,
    required this.label,
    required this.glyph,
    this.subtitle,
    this.onTap,
    this.showDivider = false,
  });

  final String label;
  final String glyph;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showDivider)
          const Divider(height: 1, indent: 16, endIndent: 16),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                            ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                    ],
                  ),
                ),
                Text(glyph, style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class QadamLifeProgressBlock extends StatelessWidget {
  const QadamLifeProgressBlock({
    super.key,
    required this.life,
    this.onTap,
  });

  final LifeProgress life;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Тебе ${life.ageYears} ${_yearsLabel(life.ageYears)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Пройдено: ${life.weeksPassed} ${_weeksLabel(life.weeksPassed)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'Осталось: ~${life.weeksRemaining} ${_weeksLabel(life.weeksRemaining)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: life.progressPercent / 100,
              minHeight: 10,
              backgroundColor: QadamTheme.weekFuture,
              color: QadamTheme.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${life.progressPercent.round()}% пути',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: QadamTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          if (onTap != null) ...[
            const SizedBox(height: 4),
            Text(
              'Карта жизни →',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 11,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  String _yearsLabel(int n) {
    final mod10 = n % 10;
    final mod100 = n % 100;
    if (mod10 == 1 && mod100 != 11) return 'год';
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
      return 'года';
    }
    return 'лет';
  }

  String _weeksLabel(int n) {
    final mod10 = n % 10;
    final mod100 = n % 100;
    if (mod10 == 1 && mod100 != 11) return 'неделя';
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
      return 'недели';
    }
    return 'недель';
  }
}

class QadamWeekSummary extends StatelessWidget {
  const QadamWeekSummary({
    super.key,
    required this.prayersDone,
    required this.prayersTotal,
    required this.quranDays,
    required this.sadaqaDays,
    required this.avgMood,
  });

  final int prayersDone;
  final int prayersTotal;
  final int quranDays;
  final int sadaqaDays;
  final int avgMood;

  @override
  Widget build(BuildContext context) {
    return QadamSoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Неделя', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          QadamTrackingRow(
            label: 'Намаз',
            glyph: '$prayersDone/$prayersTotal',
          ),
          QadamTrackingRow(
            label: 'Коран',
            glyph: '$quranDays дн.',
            showDivider: true,
          ),
          QadamTrackingRow(
            label: 'Садака',
            glyph: '$sadaqaDays дн.',
            showDivider: true,
          ),
          QadamTrackingRow(
            label: 'Настроение',
            glyph: avgMood > 0 ? '$avgMood%' : '—',
            showDivider: true,
          ),
        ],
      ),
    );
  }
}

Future<void> showQadamPrayerSheet(
  BuildContext context, {
  required String prayerTitle,
  required VoidCallback onPrayed,
  required VoidCallback onMissed,
  required VoidCallback onQaza,
}) {
  HapticFeedback.selectionClick();
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                prayerTitle,
                style: Theme.of(ctx).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  onPrayed();
                  Navigator.pop(ctx);
                },
                child: const Text('Прочитал'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  onMissed();
                  Navigator.pop(ctx);
                },
                child: const Text('Пропустил'),
              ),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () {
                  onQaza();
                  Navigator.pop(ctx);
                },
                child: const Text('Қаза прочитал'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> showQadamMoodSheet(
  BuildContext context, {
  required double initial,
  required ValueChanged<int> onSaved,
}) {
  var value = initial;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setSheetState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Настроение ${value.round()}%',
                    style: Theme.of(ctx).textTheme.headlineSmall,
                  ),
                  Slider(
                    value: value,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    onChanged: (v) => setSheetState(() => value = v),
                    onChangeEnd: (v) {
                      onSaved(v.round());
                      Navigator.pop(ctx);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
