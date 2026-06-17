import Foundation
import SQLite3

final class DatabaseManager {
    static let shared = DatabaseManager()

    private var db: OpaquePointer?
    private var snapshotCache: TrackingSnapshot?

    private init() {
        openDatabase()
        createTables()
        migrateIfNeeded()
        seedDefaultsIfNeeded()
    }

    deinit {
        if db != nil {
            sqlite3_close(db)
        }
    }

    private var dbURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("qadam.sqlite")
    }

    private func openDatabase() {
        let path = dbURL.path
        if sqlite3_open(path, &db) != SQLITE_OK {
            print("Failed to open database at \(path)")
        }
    }

    private func exec(_ sql: String) {
        var err: UnsafeMutablePointer<CChar>?
        if sqlite3_exec(db, sql, nil, nil, &err) != SQLITE_OK {
            if let err {
                print("SQL error: \(String(cString: err))")
                sqlite3_free(err)
            }
        }
    }

    private func createTables() {
        exec("""
        CREATE TABLE IF NOT EXISTS user_profiles (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            birth_date REAL NOT NULL,
            life_expectancy INTEGER NOT NULL,
            city TEXT NOT NULL,
            latitude REAL,
            longitude REAL,
            use_geolocation INTEGER NOT NULL DEFAULT 1,
            calculation_method TEXT NOT NULL,
            asr_madhab TEXT NOT NULL,
            prior_weeks_mood_score INTEGER,
            prayer_practice_start_date REAL,
            onboarding_completed INTEGER NOT NULL DEFAULT 0,
            created_at REAL NOT NULL,
            updated_at REAL NOT NULL
        );
        CREATE TABLE IF NOT EXISTS prayer_settings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            prayer_key TEXT NOT NULL UNIQUE,
            title TEXT NOT NULL,
            is_active INTEGER NOT NULL DEFAULT 0,
            is_obligatory INTEGER NOT NULL DEFAULT 0,
            sort_order INTEGER NOT NULL
        );
        CREATE TABLE IF NOT EXISTS habit_settings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            habit_key TEXT NOT NULL UNIQUE,
            title TEXT NOT NULL,
            is_active INTEGER NOT NULL DEFAULT 0,
            sort_order INTEGER NOT NULL,
            custom_title TEXT
        );
        CREATE TABLE IF NOT EXISTS day_records (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL UNIQUE,
            mood_percent INTEGER,
            quran_read INTEGER,
            sadaqa_done INTEGER,
            zikr_done INTEGER,
            note TEXT,
            created_at REAL NOT NULL,
            updated_at REAL NOT NULL
        );
        CREATE TABLE IF NOT EXISTS prayer_records (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            day_record_id INTEGER NOT NULL,
            prayer_key TEXT NOT NULL,
            prayed INTEGER NOT NULL DEFAULT 0,
            qaza_prayed INTEGER NOT NULL DEFAULT 0,
            prayed_at_mosque INTEGER NOT NULL DEFAULT 0,
            prayed_at REAL,
            created_at REAL NOT NULL,
            updated_at REAL NOT NULL,
            UNIQUE(day_record_id, prayer_key)
        );
        CREATE TABLE IF NOT EXISTS habit_records (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            day_record_id INTEGER NOT NULL,
            habit_key TEXT NOT NULL,
            completed INTEGER NOT NULL DEFAULT 0,
            created_at REAL NOT NULL,
            updated_at REAL NOT NULL,
            UNIQUE(day_record_id, habit_key)
        );
        """)
    }

    private func migrateIfNeeded() {
        exec("ALTER TABLE day_records ADD COLUMN bereke_score INTEGER;")
        exec("ALTER TABLE user_profiles ADD COLUMN prior_weeks_mood_score INTEGER;")
        exec("ALTER TABLE user_profiles ADD COLUMN prayer_practice_start_date REAL;")
        exec("ALTER TABLE prayer_records ADD COLUMN prayed_at_mosque INTEGER NOT NULL DEFAULT 0;")
    }

    private func seedDefaultsIfNeeded() {
        if getUserProfile() != nil { return }

        for (i, key) in PrayerKeys.defaultActive.enumerated() {
            upsertPrayerSetting(key: key, title: PrayerKeys.title(key), isActive: true, sortOrder: i)
        }
        for (i, key) in HabitKeys.mvpActive.enumerated() {
            upsertHabitSetting(key: key, title: HabitKeys.title(key), isActive: true, sortOrder: i)
        }
    }

    // MARK: - User Profile

    func getUserProfile() -> UserProfile? {
        let sql = "SELECT id, name, birth_date, life_expectancy, city, latitude, longitude, use_geolocation, calculation_method, asr_madhab, prior_weeks_mood_score, prayer_practice_start_date, onboarding_completed FROM user_profiles LIMIT 1"
        var stmt: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else { return nil }
        defer { sqlite3_finalize(stmt) }

        guard sqlite3_step(stmt) == SQLITE_ROW else { return nil }

        return UserProfile(
            id: sqlite3_column_int64(stmt, 0),
            name: stringColumn(stmt, 1) ?? "",
            birthDate: Date(timeIntervalSinceReferenceDate: sqlite3_column_double(stmt, 2)),
            lifeExpectancy: Int(sqlite3_column_int(stmt, 3)),
            city: stringColumn(stmt, 4) ?? "",
            latitude: optionalDouble(stmt, 5),
            longitude: optionalDouble(stmt, 6),
            useGeolocation: sqlite3_column_int(stmt, 7) != 0,
            calculationMethod: stringColumn(stmt, 8) ?? AppConstants.calculationMethods[0],
            asrMadhab: stringColumn(stmt, 9) ?? AppConstants.asrMadhabOptions[0],
            priorWeeksMoodScore: optionalInt(stmt, 10),
            prayerPracticeStartDate: optionalDouble(stmt, 11).map(Date.init(timeIntervalSinceReferenceDate:)),
            onboardingCompleted: sqlite3_column_int(stmt, 12) != 0
        )
    }

    func saveProfile(
        name: String,
        birthDate: Date,
        lifeExpectancy: Int,
        city: String,
        latitude: Double?,
        longitude: Double?,
        useGeolocation: Bool,
        calculationMethod: String,
        asrMadhab: String,
        priorWeeksMoodScore: Int?,
        prayerPracticeStartDate: Date?,
        onboardingCompleted: Bool
    ) {
        let coords = CityCoordinates.forCity(city)
        let lat = latitude ?? coords.lat
        let lng = longitude ?? coords.lng
        let now = Date().timeIntervalSinceReferenceDate

        if let existing = getUserProfile() {
            let sql = """
            UPDATE user_profiles SET name=?, birth_date=?, life_expectancy=?, city=?, latitude=?, longitude=?,
            use_geolocation=?, calculation_method=?, asr_madhab=?, prior_weeks_mood_score=?, prayer_practice_start_date=?,
            onboarding_completed=?, updated_at=? WHERE id=?
            """
            bind(sql) { stmt in
                sqlite3_bind_text(stmt, 1, name, -1, Self.transient)
                sqlite3_bind_double(stmt, 2, birthDate.timeIntervalSinceReferenceDate)
                sqlite3_bind_int(stmt, 3, Int32(lifeExpectancy))
                sqlite3_bind_text(stmt, 4, city, -1, Self.transient)
                sqlite3_bind_double(stmt, 5, lat)
                sqlite3_bind_double(stmt, 6, lng)
                sqlite3_bind_int(stmt, 7, useGeolocation ? 1 : 0)
                sqlite3_bind_text(stmt, 8, calculationMethod, -1, Self.transient)
                sqlite3_bind_text(stmt, 9, asrMadhab, -1, Self.transient)
                bindOptionalInt(stmt, 10, priorWeeksMoodScore)
                if let prayerPracticeStartDate {
                    sqlite3_bind_double(stmt, 11, prayerPracticeStartDate.timeIntervalSinceReferenceDate)
                } else {
                    sqlite3_bind_null(stmt, 11)
                }
                sqlite3_bind_int(stmt, 12, onboardingCompleted ? 1 : 0)
                sqlite3_bind_double(stmt, 13, now)
                sqlite3_bind_int64(stmt, 14, existing.id)
            }
        } else {
            let sql = """
            INSERT INTO user_profiles (name, birth_date, life_expectancy, city, latitude, longitude,
            use_geolocation, calculation_method, asr_madhab, prior_weeks_mood_score, prayer_practice_start_date,
            onboarding_completed, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """
            bind(sql) { stmt in
                sqlite3_bind_text(stmt, 1, name, -1, Self.transient)
                sqlite3_bind_double(stmt, 2, birthDate.timeIntervalSinceReferenceDate)
                sqlite3_bind_int(stmt, 3, Int32(lifeExpectancy))
                sqlite3_bind_text(stmt, 4, city, -1, Self.transient)
                sqlite3_bind_double(stmt, 5, lat)
                sqlite3_bind_double(stmt, 6, lng)
                sqlite3_bind_int(stmt, 7, useGeolocation ? 1 : 0)
                sqlite3_bind_text(stmt, 8, calculationMethod, -1, Self.transient)
                sqlite3_bind_text(stmt, 9, asrMadhab, -1, Self.transient)
                bindOptionalInt(stmt, 10, priorWeeksMoodScore)
                if let prayerPracticeStartDate {
                    sqlite3_bind_double(stmt, 11, prayerPracticeStartDate.timeIntervalSinceReferenceDate)
                } else {
                    sqlite3_bind_null(stmt, 11)
                }
                sqlite3_bind_int(stmt, 12, onboardingCompleted ? 1 : 0)
                sqlite3_bind_double(stmt, 13, now)
                sqlite3_bind_double(stmt, 14, now)
            }
        }
    }

    func updateProfile(_ profile: UserProfile) {
        let now = Date().timeIntervalSinceReferenceDate
        let sql = """
        UPDATE user_profiles SET name=?, birth_date=?, life_expectancy=?, city=?, latitude=?, longitude=?,
        use_geolocation=?, calculation_method=?, asr_madhab=?, prior_weeks_mood_score=?, prayer_practice_start_date=?,
        onboarding_completed=?, updated_at=? WHERE id=?
        """
        bind(sql) { stmt in
            sqlite3_bind_text(stmt, 1, profile.name, -1, Self.transient)
            sqlite3_bind_double(stmt, 2, profile.birthDate.timeIntervalSinceReferenceDate)
            sqlite3_bind_int(stmt, 3, Int32(profile.lifeExpectancy))
            sqlite3_bind_text(stmt, 4, profile.city, -1, Self.transient)
            if let lat = profile.latitude { sqlite3_bind_double(stmt, 5, lat) } else { sqlite3_bind_null(stmt, 5) }
            if let lng = profile.longitude { sqlite3_bind_double(stmt, 6, lng) } else { sqlite3_bind_null(stmt, 6) }
            sqlite3_bind_int(stmt, 7, profile.useGeolocation ? 1 : 0)
            sqlite3_bind_text(stmt, 8, profile.calculationMethod, -1, Self.transient)
            sqlite3_bind_text(stmt, 9, profile.asrMadhab, -1, Self.transient)
            bindOptionalInt(stmt, 10, profile.priorWeeksMoodScore)
            if let practiceDate = profile.prayerPracticeStartDate {
                sqlite3_bind_double(stmt, 11, practiceDate.timeIntervalSinceReferenceDate)
            } else {
                sqlite3_bind_null(stmt, 11)
            }
            sqlite3_bind_int(stmt, 12, profile.onboardingCompleted ? 1 : 0)
            sqlite3_bind_double(stmt, 13, now)
            sqlite3_bind_int64(stmt, 14, profile.id)
        }
    }

    func invalidateCache() {
        snapshotCache = nil
    }

    func trackingSnapshot() -> TrackingSnapshot {
        if let snapshotCache { return snapshotCache }
        let dayRecords = getAllDayRecords()
        var byDate: [String: DayRecord] = [:]
        var byId: [Int64: DayRecord] = [:]
        for record in dayRecords { byDate[record.date] = record }
        for record in dayRecords { byId[record.id] = record }

        var prayersByDay: [Int64: [PrayerRecord]] = [:]
        let allPrayers = getAllPrayerRecords()
        for prayer in allPrayers {
            prayersByDay[prayer.dayRecordId, default: []].append(prayer)
        }

        let snapshot = TrackingSnapshot(
            activePrayerKeys: getActivePrayerKeys(),
            activeHabitKeys: getActiveHabitKeys(),
            dayRecordsByDate: byDate,
            dayRecordsById: byId,
            prayerRecordsByDayId: prayersByDay
        )
        snapshotCache = snapshot
        return snapshot
    }

    func getAllPrayerRecords() -> [PrayerRecord] {
        let sql = "SELECT id, day_record_id, prayer_key, prayed, qaza_prayed, prayed_at_mosque FROM prayer_records"
        var stmt: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else { return [] }
        defer { sqlite3_finalize(stmt) }
        var records: [PrayerRecord] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            records.append(PrayerRecord(
                id: sqlite3_column_int64(stmt, 0),
                dayRecordId: sqlite3_column_int64(stmt, 1),
                prayerKey: stringColumn(stmt, 2) ?? "",
                prayed: sqlite3_column_int(stmt, 3) != 0,
                qazaPrayed: sqlite3_column_int(stmt, 4) != 0,
                prayedAtMosque: sqlite3_column_int(stmt, 5) != 0
            ))
        }
        return records
    }

    // MARK: - Settings

    func getActivePrayerKeys() -> [String] {
        let sql = "SELECT prayer_key FROM prayer_settings WHERE is_active=1 ORDER BY sort_order"
        return queryStrings(sql)
    }

    func getHabitSettings() -> [HabitSetting] {
        let sql = "SELECT id, habit_key, title, is_active, sort_order FROM habit_settings ORDER BY sort_order"
        var stmt: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else { return [] }
        defer { sqlite3_finalize(stmt) }
        var settings: [HabitSetting] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            settings.append(HabitSetting(
                id: sqlite3_column_int64(stmt, 0),
                habitKey: stringColumn(stmt, 1) ?? "",
                title: stringColumn(stmt, 2) ?? "",
                isActive: sqlite3_column_int(stmt, 3) != 0,
                sortOrder: Int(sqlite3_column_int(stmt, 4))
            ))
        }
        return settings
    }

    func setHabitActive(key: String, isActive: Bool) {
        let sql = "UPDATE habit_settings SET is_active=? WHERE habit_key=?"
        bind(sql) { stmt in
            sqlite3_bind_int(stmt, 1, isActive ? 1 : 0)
            sqlite3_bind_text(stmt, 2, key, -1, Self.transient)
        }
    }

    func getActiveHabitKeys() -> [String] {
        let sql = "SELECT habit_key FROM habit_settings WHERE is_active=1 ORDER BY sort_order"
        return queryStrings(sql)
    }

    func getAllDayRecords() -> [DayRecord] {
        let sql = "SELECT id, date, mood_percent, quran_read, sadaqa_done, bereke_score FROM day_records ORDER BY date"
        var stmt: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else { return [] }
        defer { sqlite3_finalize(stmt) }
        var records: [DayRecord] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            records.append(dayRecordFrom(stmt))
        }
        return records
    }

    private func upsertPrayerSetting(key: String, title: String, isActive: Bool, sortOrder: Int) {
        let sql = """
        INSERT INTO prayer_settings (prayer_key, title, is_active, is_obligatory, sort_order)
        VALUES (?, ?, ?, 1, ?)
        ON CONFLICT(prayer_key) DO UPDATE SET title=excluded.title, is_active=excluded.is_active, sort_order=excluded.sort_order
        """
        bind(sql) { stmt in
            sqlite3_bind_text(stmt, 1, key, -1, Self.transient)
            sqlite3_bind_text(stmt, 2, title, -1, Self.transient)
            sqlite3_bind_int(stmt, 3, isActive ? 1 : 0)
            sqlite3_bind_int(stmt, 4, Int32(sortOrder))
        }
    }

    private func upsertHabitSetting(key: String, title: String, isActive: Bool, sortOrder: Int) {
        let sql = """
        INSERT INTO habit_settings (habit_key, title, is_active, sort_order)
        VALUES (?, ?, ?, ?)
        ON CONFLICT(habit_key) DO UPDATE SET title=excluded.title, is_active=excluded.is_active, sort_order=excluded.sort_order
        """
        bind(sql) { stmt in
            sqlite3_bind_text(stmt, 1, key, -1, Self.transient)
            sqlite3_bind_text(stmt, 2, title, -1, Self.transient)
            sqlite3_bind_int(stmt, 3, isActive ? 1 : 0)
            sqlite3_bind_int(stmt, 4, Int32(sortOrder))
        }
    }

    // MARK: - Day Records

    func getDayRecord(dateKey: String) -> DayRecord? {
        let sql = "SELECT id, date, mood_percent, quran_read, sadaqa_done, bereke_score FROM day_records WHERE date=?"
        var stmt: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else { return nil }
        defer { sqlite3_finalize(stmt) }
        sqlite3_bind_text(stmt, 1, dateKey, -1, Self.transient)
        guard sqlite3_step(stmt) == SQLITE_ROW else { return nil }
        return dayRecordFrom(stmt)
    }

    func getDayRecordsInRange(from: String, to: String) -> [DayRecord] {
        let sql = "SELECT id, date, mood_percent, quran_read, sadaqa_done, bereke_score FROM day_records WHERE date BETWEEN ? AND ? ORDER BY date"
        var stmt: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else { return [] }
        defer { sqlite3_finalize(stmt) }
        sqlite3_bind_text(stmt, 1, from, -1, Self.transient)
        sqlite3_bind_text(stmt, 2, to, -1, Self.transient)
        var records: [DayRecord] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            records.append(dayRecordFrom(stmt))
        }
        return records
    }

    @discardableResult
    func upsertDayRecord(dateKey: String, moodPercent: Int?, quranRead: Bool?, sadaqaDone: Bool?, berekeScore: Int? = nil) -> Int64 {
        let now = Date().timeIntervalSinceReferenceDate
        if let existing = getDayRecord(dateKey: dateKey) {
            let score = berekeScore ?? existing.berekeScore
            let sql = "UPDATE day_records SET mood_percent=?, quran_read=?, sadaqa_done=?, bereke_score=?, updated_at=? WHERE id=?"
            bind(sql) { stmt in
                bindOptionalInt(stmt, 1, moodPercent)
                bindOptionalBool(stmt, 2, quranRead)
                bindOptionalBool(stmt, 3, sadaqaDone)
                bindOptionalInt(stmt, 4, score)
                sqlite3_bind_double(stmt, 5, now)
                sqlite3_bind_int64(stmt, 6, existing.id)
            }
            return existing.id
        }

        let sql = "INSERT INTO day_records (date, mood_percent, quran_read, sadaqa_done, bereke_score, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)"
        bind(sql) { stmt in
            sqlite3_bind_text(stmt, 1, dateKey, -1, Self.transient)
            bindOptionalInt(stmt, 2, moodPercent)
            bindOptionalBool(stmt, 3, quranRead)
            bindOptionalBool(stmt, 4, sadaqaDone)
            bindOptionalInt(stmt, 5, berekeScore)
            sqlite3_bind_double(stmt, 6, now)
            sqlite3_bind_double(stmt, 7, now)
        }
        return sqlite3_last_insert_rowid(db)
    }

    func updateBerekeScore(dateKey: String, score: Int) {
        let existing = getDayRecord(dateKey: dateKey)
        _ = upsertDayRecord(
            dateKey: dateKey,
            moodPercent: existing?.moodPercent,
            quranRead: existing?.quranRead,
            sadaqaDone: existing?.sadaqaDone,
            berekeScore: score
        )
    }

    func getPrayerRecords(dayRecordId: Int64) -> [PrayerRecord] {
        let sql = "SELECT id, day_record_id, prayer_key, prayed, qaza_prayed, prayed_at_mosque FROM prayer_records WHERE day_record_id=?"
        var stmt: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else { return [] }
        defer { sqlite3_finalize(stmt) }
        sqlite3_bind_int64(stmt, 1, dayRecordId)
        var records: [PrayerRecord] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            records.append(PrayerRecord(
                id: sqlite3_column_int64(stmt, 0),
                dayRecordId: sqlite3_column_int64(stmt, 1),
                prayerKey: stringColumn(stmt, 2) ?? "",
                prayed: sqlite3_column_int(stmt, 3) != 0,
                qazaPrayed: sqlite3_column_int(stmt, 4) != 0,
                prayedAtMosque: sqlite3_column_int(stmt, 5) != 0
            ))
        }
        return records
    }

    func upsertPrayerRecord(dayRecordId: Int64, prayerKey: String, prayed: Bool, qazaPrayed: Bool, prayedAtMosque: Bool = false) {
        let now = Date().timeIntervalSinceReferenceDate
        let sql = """
        INSERT INTO prayer_records (day_record_id, prayer_key, prayed, qaza_prayed, prayed_at_mosque, prayed_at, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ON CONFLICT(day_record_id, prayer_key) DO UPDATE SET prayed=excluded.prayed, qaza_prayed=excluded.qaza_prayed,
        prayed_at_mosque=excluded.prayed_at_mosque, prayed_at=excluded.prayed_at, updated_at=excluded.updated_at
        """
        bind(sql) { stmt in
            sqlite3_bind_int64(stmt, 1, dayRecordId)
            sqlite3_bind_text(stmt, 2, prayerKey, -1, Self.transient)
            sqlite3_bind_int(stmt, 3, prayed ? 1 : 0)
            sqlite3_bind_int(stmt, 4, qazaPrayed ? 1 : 0)
            sqlite3_bind_int(stmt, 5, prayedAtMosque ? 1 : 0)
            if prayed { sqlite3_bind_double(stmt, 6, now) } else { sqlite3_bind_null(stmt, 6) }
            sqlite3_bind_double(stmt, 7, now)
            sqlite3_bind_double(stmt, 8, now)
        }
    }

    func getDayData(for date: Date) -> DayData {
        trackingSnapshot().dayData(for: date)
    }

    func getLifeMapWeekStatuses(birthDate: Date, lifeExpectancy: Int) -> [WeekStatus] {
        trackingSnapshot().weekStatuses(birthDate: birthDate, lifeExpectancy: lifeExpectancy)
    }

    // MARK: - Helpers

    private static let transient = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

    private func bind(_ sql: String, bindBlock: (OpaquePointer?) -> Void) {
        var stmt: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else { return }
        defer { sqlite3_finalize(stmt) }
        bindBlock(stmt)
        sqlite3_step(stmt)
        invalidateCache()
    }

    private func queryStrings(_ sql: String) -> [String] {
        var stmt: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else { return [] }
        defer { sqlite3_finalize(stmt) }
        var result: [String] = []
        while sqlite3_step(stmt) == SQLITE_ROW {
            if let s = stringColumn(stmt, 0) { result.append(s) }
        }
        return result
    }

    private func dayRecordFrom(_ stmt: OpaquePointer?) -> DayRecord {
        DayRecord(
            id: sqlite3_column_int64(stmt, 0),
            date: stringColumn(stmt, 1) ?? "",
            moodPercent: optionalInt(stmt, 2),
            quranRead: optionalBool(stmt, 3),
            sadaqaDone: optionalBool(stmt, 4),
            berekeScore: optionalInt(stmt, 5)
        )
    }

    private func stringColumn(_ stmt: OpaquePointer?, _ index: Int32) -> String? {
        guard let c = sqlite3_column_text(stmt, index) else { return nil }
        return String(cString: c)
    }

    private func optionalDouble(_ stmt: OpaquePointer?, _ index: Int32) -> Double? {
        sqlite3_column_type(stmt, index) == SQLITE_NULL ? nil : sqlite3_column_double(stmt, index)
    }

    private func optionalInt(_ stmt: OpaquePointer?, _ index: Int32) -> Int? {
        sqlite3_column_type(stmt, index) == SQLITE_NULL ? nil : Int(sqlite3_column_int(stmt, index))
    }

    private func optionalBool(_ stmt: OpaquePointer?, _ index: Int32) -> Bool? {
        guard sqlite3_column_type(stmt, index) != SQLITE_NULL else { return nil }
        return sqlite3_column_int(stmt, index) != 0
    }

    private func bindOptionalInt(_ stmt: OpaquePointer?, _ index: Int32, _ value: Int?) {
        if let value { sqlite3_bind_int(stmt, index, Int32(value)) } else { sqlite3_bind_null(stmt, index) }
    }

    private func bindOptionalBool(_ stmt: OpaquePointer?, _ index: Int32, _ value: Bool?) {
        if let value { sqlite3_bind_int(stmt, index, value ? 1 : 0) } else { sqlite3_bind_null(stmt, index) }
    }
}
