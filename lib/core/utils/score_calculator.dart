/// Completion Score: completedActivePrayers / totalActivePrayers * 100
double calculateCompletionScore({
  required int completedActivePrayers,
  required int totalActivePrayers,
}) {
  if (totalActivePrayers <= 0) return 0;
  return (completedActivePrayers / totalActivePrayers * 100).clamp(0, 100);
}

/// Bereke Score (0–100):
/// - Namaz plan: up to 70
/// - Qaza closed: up to 10
/// - Quran: up to 10
/// - Sadaqa: up to 5
/// - Zikr/habits: up to 5
double calculateBerekeScore({
  required int completedActivePrayers,
  required int totalActivePrayers,
  required int missedWithQazaClosed,
  required int totalMissed,
  required bool quranDone,
  required bool quranActive,
  required bool sadaqaDone,
  required bool sadaqaActive,
  required int completedHabits,
  required int totalActiveHabits,
}) {
  var score = 0.0;

  // Prayer plan — up to 70
  if (totalActivePrayers > 0) {
    score += (completedActivePrayers / totalActivePrayers) * 70;
  }

  // Qaza closed — up to 10 (only when there were misses)
  if (totalMissed > 0) {
    score += (missedWithQazaClosed / totalMissed) * 10;
  } else if (totalActivePrayers > 0 && completedActivePrayers == totalActivePrayers) {
    score += 10;
  }

  // Quran — up to 10
  if (quranActive && quranDone) score += 10;

  // Sadaqa — up to 5
  if (sadaqaActive && sadaqaDone) score += 5;

  // Other habits (excluding quran/sadaqa which are tracked separately) — up to 5
  final otherHabits = totalActiveHabits -
      (quranActive ? 1 : 0) -
      (sadaqaActive ? 1 : 0);
  if (otherHabits > 0) {
    final otherCompleted = completedHabits -
        (quranActive && quranDone ? 1 : 0) -
        (sadaqaActive && sadaqaDone ? 1 : 0);
    score += (otherCompleted / otherHabits) * 5;
  } else if (totalActiveHabits > 0 &&
      completedHabits == totalActiveHabits) {
    score += 5;
  }

  return score.clamp(0, 100);
}
