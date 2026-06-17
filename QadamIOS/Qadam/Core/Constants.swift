import Foundation

enum AppConstants {
    static let appName = "Qadam"
    static let appSubtitle = "Өмір апталығы"
    static let lifeExpectancyOptions = [70, 80, 90]
    static let weeksPerYear = 52
    static let calculationMethods = [
        "Muslim World League",
        "Turkey",
        "Umm al-Qura",
        "Custom",
    ]
    static let asrMadhabOptions = ["Standard", "Hanafi"]
}

enum PrayerKeys {
    static let defaultActive = ["fajr", "dhuhr", "asr", "maghrib", "isha"]
    static let titles: [String: String] = [
        "fajr": "Фаджр",
        "dhuhr": "Зухр",
        "asr": "Аср",
        "maghrib": "Магриб",
        "isha": "Иша",
    ]

    static func title(_ key: String) -> String {
        titles[key] ?? key
    }

    static func title(_ key: String, on date: Date) -> String {
        if key == "dhuhr" && Calendar.current.component(.weekday, from: date) == 6 {
            return "Жума (мечеть) / Зухр"
        }
        return title(key)
    }
}

enum HabitKeys {
    static let mvpActive = ["quran", "sadaqa"]
    static let titles: [String: String] = [
        "quran": "Коран",
        "sadaqa": "Садака",
    ]

    static func title(_ key: String) -> String {
        titles[key] ?? key
    }
}
