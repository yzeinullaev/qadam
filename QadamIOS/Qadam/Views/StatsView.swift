import SwiftUI

struct StatsView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                if let stats = appState.statsSummary {
                    VStack(alignment: .leading, spacing: 16) {
                        QadamCard(elevated: true) {
                            Text(stats.insight)
                                .font(.body)
                                .foregroundStyle(QadamTheme.textOnDark)
                        }
                        .background(QadamTheme.heroGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                        moodComparison(stats)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            statTile("Зелёные недели", "\(stats.greenWeeks)", "checkmark.circle.fill", QadamTheme.weekGreen)
                            statTile("Жёлтые недели", "\(stats.yellowWeeks)", "exclamationmark.circle.fill", QadamTheme.weekYellow)
                            statTile("Красные недели", "\(stats.redWeeks)", "xmark.circle.fill", QadamTheme.weekRed)
                            statTile("Коран (месяц)", "\(stats.quranThisMonth)", "book.fill", QadamTheme.primary)
                            statTile("Садака (месяц)", "\(stats.sadaqaThisMonth)", "heart.fill", QadamTheme.gold)
                            statTile("Streak намаз", "\(stats.prayerStreak)", "flame.fill", QadamTheme.weekCurrent)
                            statTile("Streak Коран", "\(stats.quranStreak)", "sparkles", QadamTheme.primaryLight)
                            statTile("Жума в мечети", "\(stats.fridayMosqueCount)", "building.columns.fill", QadamTheme.gold)
                        }
                    }
                    .padding(16)
                } else {
                    ProgressView().padding()
                }
            }
            .background(QadamTheme.background)
            .navigationTitle("Статистика")
            .onAppear { appState.reloadStatsIfNeeded() }
            .overlay {
                if appState.statsLoading && appState.statsSummary != nil {
                    ProgressView()
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .padding(.top, 8)
                }
            }
        }
    }

    private func moodComparison(_ stats: StatsSummary) -> some View {
        QadamCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Настроение и план", icon: "chart.bar.fill")
                HStack(alignment: .bottom, spacing: 20) {
                    moodBar(title: "План", value: stats.moodOnPlanDays, color: QadamTheme.weekGreen)
                    moodBar(title: "Пропуски", value: stats.moodOnMissDays, color: QadamTheme.weekYellow)
                }
                .frame(height: 120)
                HStack(spacing: 8) {
                    moodPill("Лёгкие", stats.moodLightDays, QadamTheme.weekGreen)
                    moodPill("Обычные", stats.moodNormalDays, QadamTheme.weekCurrent)
                    moodPill("Тяжёлые", stats.moodHeavyDays, QadamTheme.weekRed)
                }
            }
        }
    }

    private func moodBar(title: String, value: Double, color: Color) -> some View {
        VStack {
            Spacer()
            RoundedRectangle(cornerRadius: 6)
                .fill(color)
                .frame(height: max(CGFloat(value), 4))
            Text("\(Int(value))%")
                .font(.caption.bold())
            Text(title)
                .font(.caption2)
                .foregroundStyle(QadamTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func statTile(_ title: String, _ value: String, _ icon: String, _ color: Color) -> some View {
        QadamCard {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Text(title)
                    .font(.caption)
                    .foregroundStyle(QadamTheme.textSecondary)
                Text(value)
                    .font(.title2.bold())
                    .foregroundStyle(QadamTheme.textPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func moodPill(_ title: String, _ count: Int, _ color: Color) -> some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text("\(title): \(count)")
                .font(.caption)
                .foregroundStyle(QadamTheme.textSecondary)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background(QadamTheme.surface)
        .clipShape(Capsule())
    }
}
