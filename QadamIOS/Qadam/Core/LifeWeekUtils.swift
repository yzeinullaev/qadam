import Foundation

enum LifeWeekUtils {
    static func totalWeeks(_ lifeExpectancy: Int) -> Int {
        lifeExpectancy * AppConstants.weeksPerYear
    }

    static func weekIndexForDate(birthDate: Date, date: Date) -> Int {
        let birthWeekStart = weekStart(birthDate)
        let targetWeekStart = weekStart(date)
        let days = Calendar.current.dateComponents([.day], from: birthWeekStart, to: targetWeekStart).day ?? 0
        return days / 7
    }

    static func weekStartForIndex(birthDate: Date, weekIndex: Int) -> Date {
        let birthWeekStart = weekStart(birthDate)
        return Calendar.current.date(byAdding: .day, value: weekIndex * 7, to: birthWeekStart) ?? birthWeekStart
    }

    static func weekEndForIndex(birthDate: Date, weekIndex: Int) -> Date {
        let start = weekStartForIndex(birthDate: birthDate, weekIndex: weekIndex)
        return Calendar.current.date(byAdding: .day, value: 6, to: start) ?? start
    }

    static func daysInWeek(birthDate: Date, weekIndex: Int) -> [Date] {
        let start = weekStartForIndex(birthDate: birthDate, weekIndex: weekIndex)
        return (0..<7).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: start) }
    }

    static func currentWeekIndex(birthDate: Date) -> Int {
        weekIndexForDate(birthDate: birthDate, date: Date())
    }

    static func lifeYearForWeekIndex(_ weekIndex: Int) -> Int {
        weekIndex / AppConstants.weeksPerYear + 1
    }

    static func firstWeekIndexOfLifeYear(_ lifeYear: Int) -> Int {
        (lifeYear - 1) * AppConstants.weeksPerYear
    }

    static func weekCountInLifeYear(lifeYear: Int, totalWeeks: Int) -> Int {
        let start = firstWeekIndexOfLifeYear(lifeYear)
        if start >= totalWeeks { return 0 }
        return min(totalWeeks - start, AppConstants.weeksPerYear)
    }

    static func currentLifeYear(birthDate: Date) -> Int {
        lifeYearForWeekIndex(currentWeekIndex(birthDate: birthDate))
    }

    static func weekStart(_ date: Date) -> Date {
        let cal = Calendar.current
        let normalized = cal.startOfDay(for: date)
        let weekday = cal.component(.weekday, from: normalized)
        let daysFromMonday = (weekday + 5) % 7
        return cal.date(byAdding: .day, value: -daysFromMonday, to: normalized) ?? normalized
    }

    static func dateKey(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f.string(from: date)
    }

    static func parseDateKey(_ key: String) -> Date? {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f.date(from: key)
    }

    static func formatDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.locale = Locale(identifier: "ru_RU")
        return f.string(from: date)
    }

    static func formatShortDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.setLocalizedDateFormatFromTemplate("d MMM")
        f.locale = Locale(identifier: "ru_RU")
        return f.string(from: date)
    }

    static func formatDayOfWeek(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "EEEE"
        f.locale = Locale(identifier: "ru_RU")
        return f.string(from: date).capitalized
    }

    static func formatMonthYear(year: Int, month: Int) -> String {
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = 1
        guard let date = Calendar.current.date(from: comps) else { return "\(month)" }
        let f = DateFormatter()
        f.dateFormat = "LLLL"
        f.locale = Locale(identifier: "ru_RU")
        let raw = f.string(from: date)
        return raw.prefix(1).uppercased() + raw.dropFirst()
    }
}
