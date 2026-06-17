import Foundation

enum DayStatusCalculator {
    static func calculateDayStatus(
        activePrayerKeys: [String],
        prayerRecords: [PrayerRecord]
    ) -> DayStatus {
        if activePrayerKeys.isEmpty { return .empty }

        let recordMap = Dictionary(uniqueKeysWithValues: prayerRecords.map { ($0.prayerKey, $0) })

        var hasAnyData = false
        var allPrayed = true
        var hasUnclosedMiss = false
        var hasMiss = false

        for key in activePrayerKeys {
            guard let record = recordMap[key] else {
                allPrayed = false
                continue
            }

            hasAnyData = true
            if record.prayed { continue }

            hasMiss = true
            allPrayed = false
            if !record.qazaPrayed {
                hasUnclosedMiss = true
            }
        }

        if !hasAnyData { return .empty }
        if allPrayed && activePrayerKeys.allSatisfy({ recordMap[$0] != nil }) {
            return .green
        }
        if hasUnclosedMiss { return .red }
        if hasMiss { return .yellow }
        return .empty
    }

    static func calculateWeekStatus(
        dayStatuses: [DayStatus],
        isFuture: Bool,
        isCurrent: Bool
    ) -> WeekStatus {
        if isFuture { return .future }
        if isCurrent && dayStatuses.allSatisfy({ $0 == .empty }) {
            return .current
        }

        let filled = dayStatuses.filter { $0 != .empty }
        if filled.isEmpty {
            return isCurrent ? .current : .empty
        }

        if filled.contains(.red) { return .red }
        if filled.contains(.yellow) { return .yellow }
        if filled.allSatisfy({ $0 == .green }) {
            return isCurrent ? .current : .green
        }
        return .empty
    }
}
