import Foundation

enum ScoreCalculator {
    static func completionScore(completed: Int, total: Int) -> Double {
        guard total > 0 else { return 0 }
        return Double(completed) / Double(total) * 100
    }

    /// Qaza counts as partial prayer credit (65%) so the day score feels fairer.
    static func berekeScore(input: BerekeInput) -> Double {
        var score = 0.0

        if input.totalActivePrayers > 0 {
            score += input.weightedPrayerCompletion / Double(input.totalActivePrayers) * 70
        }

        if input.totalMissed > 0 {
            score += Double(input.missedWithQazaClosed) / Double(input.totalMissed) * 10
        } else if input.totalActivePrayers > 0 && input.completedActivePrayers == input.totalActivePrayers {
            score += 10
        }

        if input.quranActive && input.quranDone { score += 10 }
        if input.sadaqaActive && input.sadaqaDone { score += 5 }

        let otherHabits = input.totalActiveHabits
            - (input.quranActive ? 1 : 0)
            - (input.sadaqaActive ? 1 : 0)
        if otherHabits > 0 {
            let otherCompleted = input.completedHabits
                - (input.quranActive && input.quranDone ? 1 : 0)
                - (input.sadaqaActive && input.sadaqaDone ? 1 : 0)
            score += Double(otherCompleted) / Double(otherHabits) * 5
        } else if input.totalActiveHabits > 0 && input.completedHabits == input.totalActiveHabits {
            score += 5
        }

        return min(max(score, 0), 100)
    }

    /// Soul grade for the day — not a moral judgment, just a gentle mirror.
    static func soulGrade(score: Double) -> String {
        switch score {
        case 92...: return "A+"
        case 84..<92: return "A"
        case 76..<84: return "B+"
        case 68..<76: return "B"
        case 58..<68: return "B-"
        case 48..<58: return "C+"
        case 38..<48: return "C"
        default: return "C-"
        }
    }

    static func soulGradeHint(score: Double) -> String {
        switch score {
        case 84...: return "Сильный день для души"
        case 68..<84: return "Хороший ритм"
        case 50..<68: return "Есть над чем поработать"
        default: return "Начни с малого"
        }
    }

    static func berekeInput(from data: DayData, activeHabits: [String]) -> BerekeInput {
        let recordMap = Dictionary(uniqueKeysWithValues: data.prayerRecords.map { ($0.prayerKey, $0) })
        var completed = 0
        var missed = 0
        var qazaClosed = 0
        var weighted = 0.0

        for key in data.activePrayerKeys {
            guard let record = recordMap[key] else { continue }
            if record.prayed {
                completed += 1
                weighted += 1.0
            } else if record.qazaPrayed {
                missed += 1
                qazaClosed += 1
                weighted += 0.65
            } else {
                missed += 1
            }
        }

        let quranActive = activeHabits.contains("quran")
        let sadaqaActive = activeHabits.contains("sadaqa")
        let quranDone = data.dayRecord?.quranRead == true
        let sadaqaDone = data.dayRecord?.sadaqaDone == true

        var completedHabits = 0
        for key in activeHabits {
            let done: Bool? = key == "quran" ? data.dayRecord?.quranRead : key == "sadaqa" ? data.dayRecord?.sadaqaDone : nil
            if done == true { completedHabits += 1 }
        }

        return BerekeInput(
            completedActivePrayers: completed,
            totalActivePrayers: data.activePrayerKeys.count,
            missedWithQazaClosed: qazaClosed,
            totalMissed: missed,
            weightedPrayerCompletion: weighted,
            quranDone: quranDone,
            quranActive: quranActive,
            sadaqaDone: sadaqaDone,
            sadaqaActive: sadaqaActive,
            completedHabits: completedHabits,
            totalActiveHabits: activeHabits.count
        )
    }
}

struct BerekeInput {
    let completedActivePrayers: Int
    let totalActivePrayers: Int
    let missedWithQazaClosed: Int
    let totalMissed: Int
    let weightedPrayerCompletion: Double
    let quranDone: Bool
    let quranActive: Bool
    let sadaqaDone: Bool
    let sadaqaActive: Bool
    let completedHabits: Int
    let totalActiveHabits: Int
}

enum MoodPreset: String, CaseIterable, Identifiable {
    case light
    case normal
    case heavy

    var id: String { rawValue }

    var title: String {
        switch self {
        case .light: return "Лёгкий"
        case .normal: return "Обычный"
        case .heavy: return "Тяжёлый"
        }
    }

    var emoji: String {
        switch self {
        case .light: return "😊"
        case .normal: return "😐"
        case .heavy: return "😞"
        }
    }

    var percent: Int {
        switch self {
        case .light: return 75
        case .normal: return 50
        case .heavy: return 25
        }
    }

    static func from(percent: Int?) -> MoodPreset? {
        guard let percent else { return nil }
        return allCases.min { abs($0.percent - percent) < abs($1.percent - percent) }
    }
}
