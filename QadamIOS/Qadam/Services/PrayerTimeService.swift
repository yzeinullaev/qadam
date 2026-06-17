import Foundation
import Adhan

final class PrayerTimeService {
    private let db = DatabaseManager.shared

    func getTodayPrayerTimes() -> PrayerTimeInfo? {
        guard let profile = db.getUserProfile(),
              let lat = profile.latitude,
              let lng = profile.longitude else { return nil }

        let coordinates = Coordinates(latitude: lat, longitude: lng)
        let params = calculationParams(for: profile)
        let now = Date()

        // Adhan Swift: use local calendar date; times are absolute Date (format with local TZ for display).
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: now)

        guard let prayerTimes = PrayerTimes(
            coordinates: coordinates,
            date: dateComponents,
            calculationParameters: params
        ) else { return nil }

        let times: [String: Date] = [
            "fajr": prayerTimes.fajr,
            "dhuhr": prayerTimes.dhuhr,
            "asr": prayerTimes.asr,
            "maghrib": prayerTimes.maghrib,
            "isha": prayerTimes.isha,
        ]

        let activeKeys = db.getActivePrayerKeys().filter { times[$0] != nil }
        let (nextKey, nextTime) = nextActivePrayer(prayerTimes: prayerTimes, activeKeys: activeKeys, now: now)

        return PrayerTimeInfo(
            nextPrayerKey: nextKey,
            nextPrayerTime: nextTime,
            allTimes: times
        )
    }

    /// Next obligatory prayer among active keys (skips sunrise between fajr and dhuhr).
    private func nextActivePrayer(
        prayerTimes: PrayerTimes,
        activeKeys: [String],
        now: Date
    ) -> (String?, Date?) {
        let order: [(Prayer, String)] = [
            (.fajr, "fajr"),
            (.dhuhr, "dhuhr"),
            (.asr, "asr"),
            (.maghrib, "maghrib"),
            (.isha, "isha"),
        ]

        for (prayer, key) in order {
            guard activeKeys.contains(key) else { continue }
            let time = prayerTimes.time(for: prayer)
            if time > now {
                return (key, time)
            }
        }
        return (nil, nil)
    }

    private func calculationParams(for profile: UserProfile) -> CalculationParameters {
        var params: CalculationParameters
        switch profile.calculationMethod {
        case "Turkey":
            params = CalculationMethod.turkey.params
        case "Umm al-Qura":
            params = CalculationMethod.ummAlQura.params
        case "Custom":
            params = CalculationMethod.other.params
        default:
            params = CalculationMethod.muslimWorldLeague.params
        }
        params.madhab = profile.asrMadhab == "Hanafi" ? .hanafi : .shafi
        return params
    }
}

func formatPrayerCountdown(to date: Date?) -> String {
    guard let date else { return "" }
    let seconds = max(Int(date.timeIntervalSinceNow), 0)
    return formatPrayerCountdown(seconds: seconds)
}

func formatPrayerCountdown(seconds: Int) -> String {
    let seconds = max(seconds, 0)
    let h = seconds / 3600
    let m = (seconds % 3600) / 60
    let s = seconds % 60
    if h > 0 { return "через \(h)ч \(m)м" }
    if m > 0 { return "через \(m)м \(s)с" }
    return "через \(s)с"
}

func formatPrayerTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.timeZone = .current
    formatter.locale = Locale(identifier: "ru_RU")
    return formatter.string(from: date)
}

func moodEmoji(_ percent: Int) -> String {
    switch percent {
    case 0..<20: return "😞"
    case 20..<40: return "😕"
    case 40..<60: return "😐"
    case 60..<80: return "🙂"
    default: return "😊"
    }
}
