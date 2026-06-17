import Foundation

/// In-memory snapshot for fast day/week/status lookups without N+1 SQLite queries.
struct TrackingSnapshot {
    let activePrayerKeys: [String]
    let activeHabitKeys: [String]
    let dayRecordsByDate: [String: DayRecord]
    let dayRecordsById: [Int64: DayRecord]
    let prayerRecordsByDayId: [Int64: [PrayerRecord]]

    func dayData(for date: Date) -> DayData {
        let key = LifeWeekUtils.dateKey(date)
        let dayRecord = dayRecordsByDate[key]
        let prayers = dayRecord.map { prayerRecordsByDayId[$0.id] ?? [] } ?? []
        return DayData(
            date: date,
            dateKey: key,
            dayRecord: dayRecord,
            prayerRecords: prayers,
            activePrayerKeys: activePrayerKeys,
            activeHabitKeys: activeHabitKeys
        )
    }

    func dayStatus(for dateKey: String) -> DayStatus {
        guard let date = LifeWeekUtils.parseDateKey(dateKey) else { return .empty }
        return dayData(for: date).status
    }

    func weekStatuses(birthDate: Date, lifeExpectancy: Int) -> [WeekStatus] {
        let total = LifeWeekUtils.totalWeeks(lifeExpectancy)
        let currentWeek = LifeWeekUtils.currentWeekIndex(birthDate: birthDate)
        var statuses: [WeekStatus] = []

        for weekIndex in 0..<total {
            let isFuture = weekIndex > currentWeek
            let isCurrent = weekIndex == currentWeek
            let days = LifeWeekUtils.daysInWeek(birthDate: birthDate, weekIndex: weekIndex)
            let dayStatuses = days.map { dayData(for: $0).status }
            statuses.append(DayStatusCalculator.calculateWeekStatus(
                dayStatuses: dayStatuses,
                isFuture: isFuture,
                isCurrent: isCurrent
            ))
        }
        return statuses
    }

    func allDayRecords() -> [DayRecord] {
        dayRecordsByDate.values.sorted { $0.date < $1.date }
    }

    func dayRecord(for id: Int64) -> DayRecord? {
        dayRecordsById[id]
    }
}
