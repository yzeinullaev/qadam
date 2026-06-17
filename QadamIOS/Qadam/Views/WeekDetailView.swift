import SwiftUI

struct WeekDetailView: View {
    @EnvironmentObject private var appState: AppState
    let weekIndex: Int

    var body: some View {
        let _ = appState.dataRevision
        List {
            if let profile = appState.profile {
                let days = LifeWeekUtils.daysInWeek(birthDate: profile.birthDate, weekIndex: weekIndex)
                let dayDataList = days.map { appState.dayData(for: $0) }
                let start = days.first ?? Date()
                let end = days.last ?? Date()

                Section {
                    Text("Неделя \(weekIndex + 1)")
                    Text("\(LifeWeekUtils.formatShortDate(start)) – \(LifeWeekUtils.formatShortDate(end))")
                        .foregroundStyle(QadamTheme.textSecondary)
                }

                Section("Итог недели") {
                    summaryRow("Зелёные дни", "\(dayDataList.filter { $0.status == .green }.count)")
                    summaryRow("Қаза", "\(dayDataList.filter { $0.status == .yellow }.count)")
                    summaryRow("Пропуски", "\(dayDataList.filter { $0.status == .red }.count)")
                    summaryRow("Коран", "\(dayDataList.filter { $0.dayRecord?.quranRead == true }.count)/\(days.count)")
                    summaryRow("Садака", "\(dayDataList.filter { $0.dayRecord?.sadaqaDone == true }.count)/\(days.count)")
                }

                Section("Дни") {
                    ForEach(days, id: \.self) { day in
                        NavigationLink {
                            DayDetailView(date: day)
                        } label: {
                            dayRow(appState.dayData(for: day))
                        }
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(QadamTheme.background)
        .navigationTitle("Неделя")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func summaryRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value).foregroundStyle(QadamTheme.textSecondary)
        }
    }

    private func dayRow(_ data: DayData) -> some View {
        let hasTrackingData = data.dayRecord != nil || !data.prayerRecords.isEmpty
        let score = appState.suggestedBerekeScore(for: data.date)
        return HStack {
            VStack(alignment: .leading) {
                Text(LifeWeekUtils.formatDayOfWeek(data.date))
                Text(LifeWeekUtils.formatShortDate(data.date))
                    .font(.caption)
                    .foregroundStyle(QadamTheme.textSecondary)
            }
            Spacer()
            if hasTrackingData {
                Text(ScoreCalculator.soulGrade(score: score))
                    .font(.caption.bold())
                    .foregroundStyle(QadamTheme.gold)
            } else {
                Text("—")
                    .font(.caption.bold())
                    .foregroundStyle(QadamTheme.textSecondary)
            }
            StatusDot(status: data.status)
        }
    }
}

struct DayDetailView: View {
    @EnvironmentObject private var appState: AppState
    let date: Date

    @State private var showMoodSheet = false
    @State private var prayerSheet: PrayerSheetItem?

    private var editable: Bool {
        appState.isEditable(date: date)
    }

    private var moodPreset: MoodPreset {
        let data = appState.dayData(for: date)
        return MoodPreset.from(percent: data.dayRecord?.moodPercent) ?? .normal
    }

    var body: some View {
        let _ = appState.dataRevision
        let data = appState.dayData(for: date)
        let prayed = data.prayerRecords.filter(\.prayed).count
        let hasTrackingData = data.dayRecord != nil || !data.prayerRecords.isEmpty
        let bereke = appState.suggestedBerekeScore(for: date)

        List {
            Section {
                Text(LifeWeekUtils.formatDate(date))
                row("Статус", data.status.label)
                row("Намазы", "\(prayed)/\(data.activePrayerKeys.count)")
                if !editable {
                    Text("Будущие дни нельзя редактировать")
                        .font(.caption)
                        .foregroundStyle(QadamTheme.textSecondary)
                }
            }

            Section("Bereke") {
                if hasTrackingData {
                    HStack {
                        Text(ScoreCalculator.soulGrade(score: bereke))
                            .font(.title.bold())
                            .foregroundStyle(QadamTheme.gold)
                        Spacer()
                        Text("\(Int(bereke.rounded())) / 100")
                            .foregroundStyle(QadamTheme.textSecondary)
                    }
                    Text(ScoreCalculator.soulGradeHint(score: bereke))
                        .font(.caption)
                        .foregroundStyle(QadamTheme.textSecondary)
                } else {
                    Text("Оценка появится после первых отметок")
                        .font(.caption)
                        .foregroundStyle(QadamTheme.textSecondary)
                }
            }

            Section("Намазы") {
                ForEach(data.activePrayerKeys, id: \.self) { key in
                    let record = data.prayerRecords.first { $0.prayerKey == key }
                    if editable {
                        Button {
                            prayerSheet = PrayerSheetItem(key: key)
                        } label: {
                            prayerRow(key: key, record: record)
                        }
                        .buttonStyle(.plain)
                    } else {
                        prayerRow(key: key, record: record)
                    }
                }
            }

            if !data.activeHabitKeys.isEmpty {
                Section("Привычки") {
                    ForEach(data.activeHabitKeys, id: \.self) { key in
                        if editable {
                            Button {
                                appState.toggleHabit(key, on: date)
                            } label: {
                                habitRow(key: key, data: data)
                            }
                            .buttonStyle(.plain)
                        } else {
                            habitRow(key: key, data: data)
                        }
                    }
                }
            }

            Section("Как прошёл день?") {
                if editable {
                    Button {
                        showMoodSheet = true
                    } label: {
                        HStack {
                            Text("Настроение")
                            Spacer()
                            Text("\(moodPreset.emoji) \(moodPreset.title)")
                                .foregroundStyle(QadamTheme.primary)
                        }
                    }
                    .buttonStyle(.plain)
                } else if let mood = data.dayRecord?.moodPercent,
                          let preset = MoodPreset.from(percent: mood) {
                    Text("\(preset.emoji) \(preset.title)")
                } else {
                    Text("—").foregroundStyle(QadamTheme.textSecondary)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(QadamTheme.background)
        .navigationTitle(LifeWeekUtils.formatDayOfWeek(date))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showMoodSheet) {
            MoodPickerSheet(
                selected: moodPreset,
                onSelect: { preset in
                    appState.updateMood(preset.percent, on: date)
                    showMoodSheet = false
                }
            )
            .presentationDetents([.height(280)])
        }
        .sheet(item: $prayerSheet) { item in
            let isFridayDhuhr = item.key == "dhuhr" && Calendar.current.component(.weekday, from: date) == 6
            PrayerActionSheet(
                title: PrayerKeys.title(item.key, on: date),
                onPrayed: {
                    prayerSheet = nil
                    appState.markPrayed(item.key, on: date)
                },
                onMissed: {
                    prayerSheet = nil
                    appState.markMissed(item.key, on: date)
                },
                onQaza: {
                    prayerSheet = nil
                    appState.markQaza(item.key, on: date)
                },
                onMosque: isFridayDhuhr ? {
                    prayerSheet = nil
                    appState.markDhuhrAtMosque(on: date)
                } : nil
            )
            .presentationDetents([.medium])
        }
    }

    private func row(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value).foregroundStyle(QadamTheme.textSecondary)
        }
    }

    private func prayerRow(key: String, record: PrayerRecord?) -> some View {
        let isFridayDhuhr = key == "dhuhr" && Calendar.current.component(.weekday, from: date) == 6
        return HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(PrayerKeys.title(key, on: date))
                if isFridayDhuhr && record?.prayedAtMosque == true {
                    Text("Жума в мечети")
                        .font(.caption2)
                        .foregroundStyle(QadamTheme.textSecondary)
                }
            }
            Spacer()
            Text(prayerGlyph(record: record))
                .font(.title3)
        }
        .contentShape(Rectangle())
    }

    private func habitRow(key: String, data: DayData) -> some View {
        let value: Bool? = key == "quran" ? data.dayRecord?.quranRead : data.dayRecord?.sadaqaDone
        let glyph = value == true ? "✅" : value == false ? "❌" : "○"
        return HStack {
            Text(HabitKeys.title(key))
            Spacer()
            Text(glyph).font(.title3)
        }
        .contentShape(Rectangle())
    }

    private func prayerGlyph(record: PrayerRecord?) -> String {
        guard let record else { return "○" }
        if record.prayedAtMosque { return "🕌" }
        if record.prayed { return "✅" }
        if record.qazaPrayed { return "🟡" }
        return "❌"
    }
}

private struct PrayerSheetItem: Identifiable {
    let key: String
    var id: String { key }
}

struct StatusDot: View {
    let status: DayStatus

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 12, height: 12)
    }

    private var color: Color {
        switch status {
        case .green: return QadamTheme.weekGreen
        case .yellow: return QadamTheme.weekYellow
        case .red: return QadamTheme.weekRed
        case .empty: return QadamTheme.weekEmpty
        }
    }
}
