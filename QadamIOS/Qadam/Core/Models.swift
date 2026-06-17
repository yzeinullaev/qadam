import Foundation

struct UserProfile: Identifiable, Codable {
    var id: Int64
    var name: String
    var birthDate: Date
    var lifeExpectancy: Int
    var city: String
    var latitude: Double?
    var longitude: Double?
    var useGeolocation: Bool
    var calculationMethod: String
    var asrMadhab: String
    var priorWeeksMoodScore: Int?
    var prayerPracticeStartDate: Date?
    var onboardingCompleted: Bool
}

struct DayRecord: Identifiable, Codable {
    var id: Int64
    var date: String
    var moodPercent: Int?
    var quranRead: Bool?
    var sadaqaDone: Bool?
    var berekeScore: Int?
}

struct HabitSetting: Identifiable {
    var id: Int64
    var habitKey: String
    var title: String
    var isActive: Bool
    var sortOrder: Int
}

struct StatsSummary {
    let moodOnPlanDays: Double
    let moodOnMissDays: Double
    let greenWeeks: Int
    let yellowWeeks: Int
    let redWeeks: Int
    let quranThisMonth: Int
    let sadaqaThisMonth: Int
    let prayerStreak: Int
    let quranStreak: Int
    let moodLightDays: Int
    let moodNormalDays: Int
    let moodHeavyDays: Int
    let fridayMosqueCount: Int
    let insight: String
}

struct PrayerRecord: Identifiable, Codable {
    var id: Int64
    var dayRecordId: Int64
    var prayerKey: String
    var prayed: Bool
    var qazaPrayed: Bool
    var prayedAtMosque: Bool
}

struct LifeProgress {
    let ageYears: Int
    let weeksPassed: Int
    let weeksRemaining: Int
    let totalWeeks: Int
    let progressPercent: Double

    static func fromProfile(_ profile: UserProfile) -> LifeProgress {
        let birth = profile.birthDate
        let now = Date()
        var age = Calendar.current.dateComponents([.year], from: birth, to: now).year ?? 0
        age = min(max(age, 0), profile.lifeExpectancy)

        let total = LifeWeekUtils.totalWeeks(profile.lifeExpectancy)
        let passed = LifeWeekUtils.currentWeekIndex(birthDate: birth) + 1
        let remaining = max(total - passed, 0)
        let percent = total > 0 ? Double(passed) / Double(total) * 100 : 0

        return LifeProgress(
            ageYears: age,
            weeksPassed: passed,
            weeksRemaining: remaining,
            totalWeeks: total,
            progressPercent: percent
        )
    }
}

struct DayData {
    let date: Date
    let dateKey: String
    let dayRecord: DayRecord?
    let prayerRecords: [PrayerRecord]
    let activePrayerKeys: [String]
    let activeHabitKeys: [String]

    var status: DayStatus {
        DayStatusCalculator.calculateDayStatus(
            activePrayerKeys: activePrayerKeys,
            prayerRecords: prayerRecords
        )
    }
}

struct PrayerTimeInfo {
    let nextPrayerKey: String?
    let nextPrayerTime: Date?
    let allTimes: [String: Date]
}
