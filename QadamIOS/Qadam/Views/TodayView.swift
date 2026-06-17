import SwiftUI

struct TodayView: View {
    @EnvironmentObject private var appState: AppState
    @State private var prayerSheet: PrayerSheetItem?
    @State private var showMoodSheet = false
    @State private var countdownNow = Date()

    private var berekeScore: Double {
        appState.suggestedBerekeScore
    }

    private var moodPreset: MoodPreset {
        MoodPreset.from(percent: appState.todayData?.dayRecord?.moodPercent) ?? .normal
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    heroCard
                    berekeCard
                    prayerSection
                    habitSection
                    moodSection
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(QadamTheme.background)
            .refreshable {
                appState.refreshToday()
                if appState.profile?.useGeolocation == true {
                    await appState.refreshLocation()
                }
            }
            .sheet(item: $prayerSheet) { item in
                let isFridayDhuhr = item.key == "dhuhr" && Calendar.current.component(.weekday, from: Date()) == 6
                PrayerActionSheet(
                    title: PrayerKeys.title(item.key, on: Date()),
                    onPrayed: {
                        prayerSheet = nil
                        appState.markPrayed(item.key)
                    },
                    onMissed: {
                        prayerSheet = nil
                        appState.markMissed(item.key)
                    },
                    onQaza: {
                        prayerSheet = nil
                        appState.markQaza(item.key)
                    },
                    onMosque: isFridayDhuhr ? {
                        prayerSheet = nil
                        appState.markDhuhrAtMosque()
                    } : nil
                )
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $showMoodSheet) {
                MoodPickerSheet(
                    selected: moodPreset,
                    onSelect: { preset in
                        appState.updateMood(preset.percent)
                        showMoodSheet = false
                    }
                )
                .presentationDetents([.height(280)])
            }
            .task {
                while !Task.isCancelled {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    countdownNow = Date()
                    if let next = appState.prayerTimes?.nextPrayerTime,
                       next.timeIntervalSince(countdownNow) <= 0 {
                        appState.refreshPrayerTimes()
                    }
                }
            }
        }
    }

    private var heroCard: some View {
        QadamCard(elevated: true) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(AppConstants.appName)
                            .font(.title2.bold())
                            .foregroundStyle(QadamTheme.textOnDark)
                        Text(AppConstants.appSubtitle)
                            .font(.caption)
                            .foregroundStyle(QadamTheme.goldLight)
                    }
                    Spacer()
                    if let city = appState.profile?.city {
                        Label(city, systemImage: "location.fill")
                            .font(.caption2)
                            .foregroundStyle(QadamTheme.goldLight)
                    }
                }

                if let name = appState.profile?.name, !name.isEmpty {
                    Text("Ассалаумағалейкум, \(name)")
                        .font(.subheadline)
                        .foregroundStyle(QadamTheme.textOnDark.opacity(0.9))
                }
                if let practiceStart = appState.profile?.prayerPracticeStartDate {
                    Text("Ты в намазе уже \(formatPrayerJourney(since: practiceStart))")
                        .font(.caption)
                        .foregroundStyle(QadamTheme.goldLight)
                }

                Divider().overlay(QadamTheme.gold.opacity(0.3))

                if let key = appState.prayerTimes?.nextPrayerKey,
                   let nextTime = appState.prayerTimes?.nextPrayerTime {
                    let remaining = nextTime.timeIntervalSince(countdownNow)

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Следующий намаз")
                                .font(.caption)
                                .foregroundStyle(QadamTheme.goldLight)
                            if remaining > 0 {
                                Text("\(PrayerKeys.title(key)) · \(formatPrayerCountdown(seconds: Int(remaining)))")
                                    .font(.headline)
                                    .foregroundStyle(QadamTheme.gold)
                            } else {
                                Text("\(PrayerKeys.title(key)) · сейчас")
                                    .font(.headline)
                                    .foregroundStyle(QadamTheme.gold)
                            }
                        }
                        Spacer()
                        if remaining > 0 {
                            Text(formatPrayerTime(nextTime))
                                .font(.caption)
                                .foregroundStyle(QadamTheme.goldLight)
                        }
                    }
                } else {
                    Text("Включите геолокацию для времени намаза")
                        .font(.caption)
                        .foregroundStyle(QadamTheme.goldLight)
                }
            }
        }
        .background(QadamTheme.heroGradient)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var berekeCard: some View {
        QadamCard {
            VStack(alignment: .leading, spacing: 10) {
                SectionHeader(title: "Bereke Score", icon: "sparkles")

                HStack(alignment: .firstTextBaseline) {
                    Text(ScoreCalculator.soulGrade(score: berekeScore))
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundStyle(QadamTheme.primary)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(Int(berekeScore.rounded())) / 100")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(QadamTheme.textPrimary)
                        Text(ScoreCalculator.soulGradeHint(score: berekeScore))
                            .font(.caption2)
                            .foregroundStyle(QadamTheme.textSecondary)
                    }
                    Spacer()
                }

                Text("Авторасчёт по намазам, қаза и привычкам")
                    .font(.caption2)
                    .foregroundStyle(QadamTheme.textSecondary)
            }
        }
    }

    private var prayerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Намазы", icon: "moon.stars.fill")
            QadamCard {
                if let data = appState.todayData {
                    ForEach(Array(data.activePrayerKeys.enumerated()), id: \.offset) { index, key in
                        let record = data.prayerRecords.first { $0.prayerKey == key }
                        let isFridayDhuhr = key == "dhuhr" && Calendar.current.component(.weekday, from: data.date) == 6
                        TrackingRow(
                            label: PrayerKeys.title(key, on: data.date),
                            glyph: prayerGlyph(record: record),
                            subtitle: prayerSubtitle(record: record, isFridayDhuhr: isFridayDhuhr),
                            showDivider: index > 0
                        ) {
                            prayerSheet = PrayerSheetItem(key: key)
                        }
                    }
                }
            }
        }
    }

    private var habitSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Привычки", icon: "leaf.fill")
            QadamCard {
                if let data = appState.todayData {
                    let habits = data.activeHabitKeys
                    if habits.isEmpty {
                        Text("Включите привычки в настройках")
                            .font(.caption)
                            .foregroundStyle(QadamTheme.textSecondary)
                    } else {
                        ForEach(Array(habits.enumerated()), id: \.offset) { index, key in
                            let value: Bool? = key == "quran" ? data.dayRecord?.quranRead : data.dayRecord?.sadaqaDone
                            let glyph = value == true ? "✅" : value == false ? "❌" : "○"
                            TrackingRow(
                                label: HabitKeys.title(key),
                                glyph: glyph,
                                showDivider: index > 0
                            ) {
                                appState.toggleHabit(key)
                            }
                        }
                    }
                }
            }
        }
    }

    private var moodSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Как прошёл день?", icon: "face.smiling")
            QadamCard {
                Button {
                    showMoodSheet = true
                } label: {
                    HStack {
                        Text("Настроение")
                            .foregroundStyle(QadamTheme.textPrimary)
                        Spacer()
                        Text("\(moodPreset.emoji) \(moodPreset.title)")
                            .font(.headline)
                            .foregroundStyle(QadamTheme.primary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func prayerGlyph(record: PrayerRecord?) -> String {
        guard let record else { return "○" }
        if record.prayedAtMosque { return "🕌" }
        if record.prayed { return "✅" }
        if record.qazaPrayed { return "🟡" }
        return "❌"
    }

    private func prayerSubtitle(record: PrayerRecord?, isFridayDhuhr: Bool) -> String? {
        if record?.qazaPrayed == true && record?.prayed == false { return "Қаза" }
        if isFridayDhuhr && record?.prayedAtMosque == true { return "Жума в мечети" }
        return nil
    }

    private func formatPrayerJourney(since date: Date) -> String {
        let comps = Calendar.current.dateComponents([.year, .month], from: date, to: Date())
        let years = max(comps.year ?? 0, 0)
        let months = max(comps.month ?? 0, 0)
        if years > 0 {
            return "\(years) г \(months) мес"
        }
        return "\(months) мес"
    }
}

struct MoodPickerSheet: View {
    let selected: MoodPreset
    let onSelect: (MoodPreset) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Как прошёл день?")
                .font(.title3.bold())
                .padding(.top, 8)

            VStack(spacing: 12) {
                ForEach(MoodPreset.allCases) { preset in
                    Button {
                        onSelect(preset)
                    } label: {
                        HStack {
                            Text("\(preset.emoji) \(preset.title)")
                                .font(.headline)
                            Spacer()
                            if preset == selected {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(QadamTheme.primary)
                            }
                        }
                        .padding()
                        .background(preset == selected ? QadamTheme.gold.opacity(0.15) : QadamTheme.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay {
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(preset == selected ? QadamTheme.gold : QadamTheme.cardBorder, lineWidth: 1)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)

            Spacer(minLength: 0)
        }
    }
}

private struct PrayerSheetItem: Identifiable {
    let key: String
    var id: String { key }
}

struct PrayerActionSheet: View {
    let title: String
    let onPrayed: () -> Void
    let onMissed: () -> Void
    let onQaza: () -> Void
    var onMosque: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 16) {
            Text(title).font(.title2.bold())
            if let onMosque {
                Button("Жума в мечети", action: onMosque).buttonStyle(.borderedProminent).tint(QadamTheme.gold)
            }
            Button("Выполнено", action: onPrayed).buttonStyle(.borderedProminent).tint(QadamTheme.primary)
            Button("Пропустил", action: onMissed).buttonStyle(.bordered)
            Button("Қаза", action: onQaza).buttonStyle(.bordered)
        }
        .padding()
    }
}

struct LifeProgressBlock: View {
    let life: LifeProgress

    var body: some View {
        QadamCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("Прогресс жизни")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(QadamTheme.gold)
                Text("\(life.ageYears) лет · неделя \(life.weeksPassed) из \(life.totalWeeks)")
                    .font(.headline)
                    .foregroundStyle(QadamTheme.textPrimary)
                ProgressView(value: life.progressPercent, total: 100)
                    .tint(QadamTheme.gold)
                Text(String(format: "%.1f%% пройдено", life.progressPercent))
                    .font(.caption)
                    .foregroundStyle(QadamTheme.textSecondary)
            }
        }
    }
}

struct TrackingRow: View {
    let label: String
    let glyph: String
    var subtitle: String? = nil
    var showDivider = false
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            if showDivider {
                Divider().overlay(QadamTheme.cardBorder).padding(.bottom, 10)
            }
            Button { action?() } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(label).foregroundStyle(QadamTheme.textPrimary)
                        if let subtitle {
                            Text(subtitle).font(.caption).foregroundStyle(QadamTheme.textSecondary)
                        }
                    }
                    Spacer()
                    Text(glyph).font(.title3)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.vertical, 2)
        }
    }
}
