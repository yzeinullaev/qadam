import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/models/day_status.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final DayStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (status) {
      DayStatus.green => (QadamTheme.weekGreen, Icons.check_circle),
      DayStatus.yellow => (QadamTheme.weekYellow, Icons.schedule),
      DayStatus.red => (QadamTheme.weekRed, Icons.cancel),
      DayStatus.empty => (Colors.grey, Icons.remove_circle_outline),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

Color weekStatusColor(WeekStatus status) {
  return switch (status) {
    WeekStatus.green => QadamTheme.weekGreen,
    WeekStatus.yellow => QadamTheme.weekYellow,
    WeekStatus.red => QadamTheme.weekRed,
    WeekStatus.current => QadamTheme.weekCurrent,
    WeekStatus.future => QadamTheme.weekFuture,
    WeekStatus.empty => QadamTheme.weekEmpty,
  };
}
