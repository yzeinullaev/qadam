import '../../data/local/app_database.dart';
import 'life_week_utils.dart';

/// Сводка «путь жизни» для главного экрана.
class LifeProgress {
  const LifeProgress({
    required this.ageYears,
    required this.weeksPassed,
    required this.weeksRemaining,
    required this.totalWeeks,
    required this.progressPercent,
  });

  final int ageYears;
  final int weeksPassed;
  final int weeksRemaining;
  final int totalWeeks;
  final double progressPercent;

  factory LifeProgress.fromProfile(UserProfile profile) {
    final birth = profile.birthDate;
    final now = DateTime.now();
    var age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    age = age.clamp(0, profile.lifeExpectancy);

    final total = LifeWeekUtils.totalWeeks(profile.lifeExpectancy);
    final passed = LifeWeekUtils.currentWeekIndex(birth) + 1;
    final remaining = (total - passed).clamp(0, total);
    final percent = total > 0 ? (passed / total) * 100 : 0.0;

    return LifeProgress(
      ageYears: age,
      weeksPassed: passed,
      weeksRemaining: remaining,
      totalWeeks: total,
      progressPercent: percent,
    );
  }
}
