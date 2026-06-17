import Foundation
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var profile: UserProfile?
    @Published var todayData: DayData?
    @Published var prayerTimes: PrayerTimeInfo?
    @Published var weekStatuses: [WeekStatus] = []
    @Published var yearSummaries: [Int: LifeYearSummary] = [:]
    @Published var statsSummary: StatsSummary?
    @Published var statsLoading = false
    @Published var habitSettings: [HabitSetting] = []
    @Published var detectedCity: String?
    @Published var isLoading = true
    @Published private(set) var dataRevision = 0

    let locationService = LocationService()

    private let db = DatabaseManager.shared
    private let prayerService = PrayerTimeService()
    private var statsTask: Task<Void, Never>?

    var onboardingCompleted: Bool {
        profile?.onboardingCompleted == true
    }

    func load() {
        isLoading = true
        profile = db.getUserProfile()
        habitSettings = db.getHabitSettings()
        if let profile, profile.onboardingCompleted {
            db.invalidateCache()
            refreshToday()
            reloadWeekStatuses()
            scheduleStatsReload(immediate: true)
            if profile.useGeolocation {
                Task { await refreshLocation() }
            }
        }
        isLoading = false
    }

    func completeOnboarding(
        name: String,
        birthDate: Date,
        lifeExpectancy: Int,
        city: String,
        useGeolocation: Bool,
        priorWeeksMoodScore: Int?,
        prayerPracticeStartDate: Date?
    ) async {
        var resolvedCity = city
        var lat: Double?
        var lng: Double?

        if useGeolocation {
            let result = await locationService.requestLocation()
            lat = result.coordinate?.latitude
            lng = result.coordinate?.longitude
            if let detected = result.city, !detected.isEmpty {
                resolvedCity = detected
                detectedCity = detected
            }
        }

        if lat == nil || lng == nil {
            let coords = CityCoordinates.forCity(resolvedCity)
            lat = coords.lat
            lng = coords.lng
        }

        db.saveProfile(
            name: name,
            birthDate: birthDate,
            lifeExpectancy: lifeExpectancy,
            city: resolvedCity,
            latitude: lat,
            longitude: lng,
            useGeolocation: useGeolocation,
            calculationMethod: AppConstants.calculationMethods[0],
            asrMadhab: AppConstants.asrMadhabOptions[0],
            priorWeeksMoodScore: priorWeeksMoodScore,
            prayerPracticeStartDate: prayerPracticeStartDate,
            onboardingCompleted: true
        )
        load()
    }

    func refreshLocation() async {
        let result = await locationService.requestLocation()
        guard var profile else { return }
        if let coord = result.coordinate {
            profile.latitude = coord.latitude
            profile.longitude = coord.longitude
            if let city = result.city, !city.isEmpty {
                profile.city = city
                detectedCity = city
            }
            db.updateProfile(profile)
            self.profile = db.getUserProfile()
            refreshToday()
        }
    }

    func refreshToday() {
        todayData = db.getDayData(for: Date())
        refreshPrayerTimes()
    }

    func refreshPrayerTimes() {
        prayerTimes = prayerService.getTodayPrayerTimes()
    }

    func updateProfile(_ profile: UserProfile) {
        db.updateProfile(profile)
        self.profile = db.getUserProfile()
        afterDataChange()
    }

    func setHabitActive(key: String, isActive: Bool) {
        db.setHabitActive(key: key, isActive: isActive)
        habitSettings = db.getHabitSettings()
        afterDataChange()
    }

    func suggestedBerekeScore(for date: Date) -> Double {
        let data = db.getDayData(for: date)
        return ScoreCalculator.berekeScore(input: ScoreCalculator.berekeInput(from: data, activeHabits: data.activeHabitKeys))
    }

    func displayBerekeScore(for date: Date) -> Double {
        let data = db.getDayData(for: date)
        if let stored = data.dayRecord?.berekeScore {
            return Double(stored)
        }
        return suggestedBerekeScore(for: date)
    }

    var suggestedBerekeScore: Double {
        suggestedBerekeScore(for: Date())
    }

    var displayBerekeScore: Double {
        displayBerekeScore(for: Date())
    }

    func isEditable(date: Date) -> Bool {
        let day = Calendar.current.startOfDay(for: date)
        let today = Calendar.current.startOfDay(for: Date())
        return day <= today
    }

    func markPrayed(_ key: String, on date: Date = Date()) {
        guard isEditable(date: date), let dayId = ensureRecord(for: date) else { return }
        db.upsertPrayerRecord(dayRecordId: dayId, prayerKey: key, prayed: true, qazaPrayed: false, prayedAtMosque: false)
        afterDataChange()
    }

    func markMissed(_ key: String, on date: Date = Date()) {
        guard isEditable(date: date), let dayId = ensureRecord(for: date) else { return }
        db.upsertPrayerRecord(dayRecordId: dayId, prayerKey: key, prayed: false, qazaPrayed: false, prayedAtMosque: false)
        afterDataChange()
    }

    func markQaza(_ key: String, on date: Date = Date()) {
        guard isEditable(date: date), let dayId = ensureRecord(for: date) else { return }
        db.upsertPrayerRecord(dayRecordId: dayId, prayerKey: key, prayed: false, qazaPrayed: true, prayedAtMosque: false)
        afterDataChange()
    }

    func markDhuhrAtMosque(on date: Date = Date()) {
        guard isEditable(date: date), let dayId = ensureRecord(for: date) else { return }
        db.upsertPrayerRecord(dayRecordId: dayId, prayerKey: "dhuhr", prayed: true, qazaPrayed: false, prayedAtMosque: true)
        afterDataChange()
    }

    func toggleHabit(_ key: String, on date: Date = Date()) {
        guard isEditable(date: date) else { return }
        let data = db.getDayData(for: date)
        _ = db.upsertDayRecord(
            dateKey: data.dateKey,
            moodPercent: data.dayRecord?.moodPercent,
            quranRead: key == "quran" ? toggled(data.dayRecord?.quranRead) : data.dayRecord?.quranRead,
            sadaqaDone: key == "sadaqa" ? toggled(data.dayRecord?.sadaqaDone) : data.dayRecord?.sadaqaDone,
            berekeScore: data.dayRecord?.berekeScore
        )
        afterDataChange()
    }

    func updateMood(_ percent: Int, on date: Date = Date()) {
        guard isEditable(date: date) else { return }
        let data = db.getDayData(for: date)
        db.upsertDayRecord(
            dateKey: data.dateKey,
            moodPercent: percent,
            quranRead: data.dayRecord?.quranRead,
            sadaqaDone: data.dayRecord?.sadaqaDone,
            berekeScore: data.dayRecord?.berekeScore
        )
        afterDataChange(lightweight: true)
    }

    func updateBerekeScore(_ score: Int, on date: Date = Date()) {
        guard isEditable(date: date) else { return }
        let key = LifeWeekUtils.dateKey(date)
        db.updateBerekeScore(dateKey: key, score: score)
        afterDataChange(lightweight: true)
    }

    func resetBerekeScoreToSuggested(on date: Date = Date()) {
        guard isEditable(date: date) else { return }
        let suggested = Int(suggestedBerekeScore(for: date).rounded())
        let key = LifeWeekUtils.dateKey(date)
        db.updateBerekeScore(dateKey: key, score: suggested)
        afterDataChange(lightweight: true)
    }

    func updateBerekeScore(_ score: Int) {
        updateBerekeScore(score, on: Date())
    }

    func resetBerekeScoreToSuggested() {
        resetBerekeScoreToSuggested(on: Date())
    }

    func markPrayed(_ key: String) {
        markPrayed(key, on: Date())
    }

    func markMissed(_ key: String) {
        markMissed(key, on: Date())
    }

    func markQaza(_ key: String) {
        markQaza(key, on: Date())
    }

    func toggleHabit(_ key: String) {
        toggleHabit(key, on: Date())
    }

    func updateMood(_ percent: Int) {
        updateMood(percent, on: Date())
    }

    func dayData(for date: Date) -> DayData {
        db.getDayData(for: date)
    }

    func reloadStatsIfNeeded() {
        if statsSummary == nil {
            scheduleStatsReload(immediate: true)
        }
    }

    private func afterDataChange(lightweight: Bool = false) {
        db.invalidateCache()
        dataRevision += 1
        refreshToday()
        scheduleStatsReload(immediate: false)
        guard !lightweight else { return }
        reloadWeekStatuses()
    }

    private func ensureRecord(for date: Date) -> Int64? {
        let key = LifeWeekUtils.dateKey(date)
        let existing = db.getDayRecord(dateKey: key)
        return db.upsertDayRecord(
            dateKey: key,
            moodPercent: existing?.moodPercent,
            quranRead: existing?.quranRead,
            sadaqaDone: existing?.sadaqaDone,
            berekeScore: existing?.berekeScore
        )
    }

    private func ensureTodayRecord() -> Int64? {
        ensureRecord(for: Date())
    }

    private func toggled(_ value: Bool?) -> Bool? {
        switch value {
        case nil: return true
        case true: return false
        case false: return nil
        }
    }

    private func reloadWeekStatuses() {
        guard let profile else { return }
        let birth = profile.birthDate
        let expectancy = profile.lifeExpectancy

        Task {
            let snap = db.trackingSnapshot()
            let result = await Task.detached(priority: .userInitiated) {
                let weeks = snap.weekStatuses(birthDate: birth, lifeExpectancy: expectancy)
                let summaries = LifeMapData.yearSummaries(
                    profile: profile,
                    weekStatuses: weeks
                )
                return (weeks, summaries)
            }.value

            guard !Task.isCancelled else { return }
            weekStatuses = result.0
            yearSummaries = result.1
        }
    }

    private func scheduleStatsReload(immediate: Bool) {
        statsTask?.cancel()
        if statsSummary == nil { statsLoading = true }
        let currentProfile = profile

        statsTask = Task {
            if !immediate {
                try? await Task.sleep(nanoseconds: 500_000_000)
            }
            guard !Task.isCancelled, let currentProfile else {
                statsLoading = false
                return
            }

            let snap = db.trackingSnapshot()
            let summary = await Task.detached(priority: .userInitiated) {
                let weeks = snap.weekStatuses(
                    birthDate: currentProfile.birthDate,
                    lifeExpectancy: currentProfile.lifeExpectancy
                )
                return StatsService.buildSummary(snapshot: snap, weekStatuses: weeks, profile: currentProfile)
            }.value

            guard !Task.isCancelled else { return }
            statsSummary = summary
            statsLoading = false
        }
    }
}
