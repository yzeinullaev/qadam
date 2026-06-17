import Foundation

enum StatsService {
    static func buildSummary(
        snapshot: TrackingSnapshot,
        weekStatuses: [WeekStatus],
        profile: UserProfile
    ) -> StatsSummary {
        let records = snapshot.allDayRecords()
        if records.isEmpty {
            return StatsSummary(
                moodOnPlanDays: 0, moodOnMissDays: 0,
                greenWeeks: 0, yellowWeeks: 0, redWeeks: 0,
                quranThisMonth: 0, sadaqaThisMonth: 0,
                prayerStreak: 0, quranStreak: 0,
                moodLightDays: 0, moodNormalDays: 0, moodHeavyDays: 0,
                fridayMosqueCount: 0,
                insight: "Отмечай дни — здесь появится статистика"
            )
        }

        var moodPlanSum = 0, moodPlanCount = 0
        var moodMissSum = 0, moodMissCount = 0
        let cal = Calendar.current
        let now = Date()
        let monthStart = cal.date(from: cal.dateComponents([.year, .month], from: now)) ?? now
        var quranMonth = 0, sadaqaMonth = 0
        var moodLightDays = 0, moodNormalDays = 0, moodHeavyDays = 0
        var fridayMosqueCount = 0

        for record in records {
            let status = snapshot.dayStatus(for: record.date)
            if let mood = record.moodPercent {
                if status == .green {
                    moodPlanSum += mood; moodPlanCount += 1
                } else if status == .red || status == .yellow {
                    moodMissSum += mood; moodMissCount += 1
                }
                if mood >= 67 { moodLightDays += 1 }
                else if mood >= 34 { moodNormalDays += 1 }
                else { moodHeavyDays += 1 }
            }
            if let date = LifeWeekUtils.parseDateKey(record.date), date >= monthStart {
                if record.quranRead == true { quranMonth += 1 }
                if record.sadaqaDone == true { sadaqaMonth += 1 }
            }
        }

        for prayerRecords in snapshot.prayerRecordsByDayId.values {
            for prayer in prayerRecords where prayer.prayerKey == "dhuhr" && prayer.prayedAtMosque {
                guard let dayRecord = snapshot.dayRecord(for: prayer.dayRecordId),
                      let date = LifeWeekUtils.parseDateKey(dayRecord.date) else { continue }
                if Calendar.current.component(.weekday, from: date) == 6 {
                    fridayMosqueCount += 1
                }
            }
        }

        let moodPlan = moodPlanCount > 0 ? Double(moodPlanSum) / Double(moodPlanCount) : 0
        let moodMiss = moodMissCount > 0 ? Double(moodMissSum) / Double(moodMissCount) : 0

        let insight: String
        let trackedWeeks = weekStatuses.filter { $0 == .green || $0 == .yellow || $0 == .red }.count
        let totalWeeks = weekStatuses.count
        let prior = profile.priorWeeksMoodScore
        if moodPlanCount > 0 && moodMissCount > 0 {
            let priorText: String
            if let prior {
                let estimated = prior * 20
                priorText = " На старте вы оценили прошлые недели примерно на \(estimated)%."
            } else {
                priorText = ""
            }
            insight = "В отмеченные дни: при выполненном плане настроение в среднем \(Int(moodPlan))%, при пропусках — \(Int(moodMiss))%. Учтено недель: \(trackedWeeks) из \(totalWeeks).\(priorText)"
        } else {
            insight = "Продолжай отмечать намазы и настроение — сейчас учитываются только заполненные недели (\(trackedWeeks) из \(totalWeeks))."
        }

        return StatsSummary(
            moodOnPlanDays: moodPlan,
            moodOnMissDays: moodMiss,
            greenWeeks: weekStatuses.filter { $0 == .green }.count,
            yellowWeeks: weekStatuses.filter { $0 == .yellow }.count,
            redWeeks: weekStatuses.filter { $0 == .red }.count,
            quranThisMonth: quranMonth,
            sadaqaThisMonth: sadaqaMonth,
            prayerStreak: prayerStreak(records: records, snapshot: snapshot),
            quranStreak: quranStreak(records: records),
            moodLightDays: moodLightDays,
            moodNormalDays: moodNormalDays,
            moodHeavyDays: moodHeavyDays,
            fridayMosqueCount: fridayMosqueCount,
            insight: insight
        )
    }

    private static func prayerStreak(records: [DayRecord], snapshot: TrackingSnapshot) -> Int {
        let sorted = records.sorted { $0.date > $1.date }
        var streak = 0
        var expected = Calendar.current.startOfDay(for: Date())

        for record in sorted {
            guard let date = LifeWeekUtils.parseDateKey(record.date) else { continue }
            let day = Calendar.current.startOfDay(for: date)
            if day > expected { continue }
            if day < expected { break }
            let status = snapshot.dayStatus(for: record.date)
            if status == .green {
                streak += 1
                expected = Calendar.current.date(byAdding: .day, value: -1, to: expected) ?? expected
            } else if status != .empty {
                break
            } else {
                expected = Calendar.current.date(byAdding: .day, value: -1, to: expected) ?? expected
            }
        }
        return streak
    }

    private static func quranStreak(records: [DayRecord]) -> Int {
        let sorted = records.sorted { $0.date > $1.date }
        var streak = 0
        var expected = Calendar.current.startOfDay(for: Date())

        for record in sorted {
            guard let date = LifeWeekUtils.parseDateKey(record.date) else { continue }
            let day = Calendar.current.startOfDay(for: date)
            if day > expected { continue }
            if day < expected { break }
            if record.quranRead == true {
                streak += 1
                expected = Calendar.current.date(byAdding: .day, value: -1, to: expected) ?? expected
            } else if record.moodPercent != nil || record.quranRead != nil {
                break
            } else {
                expected = Calendar.current.date(byAdding: .day, value: -1, to: expected) ?? expected
            }
        }
        return streak
    }
}
