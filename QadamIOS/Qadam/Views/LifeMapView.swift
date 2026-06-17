import SwiftUI

// MARK: - Root

struct LifeMapView: View {
    private var currentYear: Int {
        Calendar.current.component(.year, from: Date())
    }

    var body: some View {
        NavigationStack {
            LifeYearView(year: currentYear, showsYearsEntry: true)
                .background(QadamTheme.background)
                .navigationTitle("Карта жизни")
                .navigationDestination(for: LifeYearsRoute.self) { _ in
                    LifeYearsPaginatedView()
                }
        }
    }
}

struct LifeYearsRoute: Hashable {}

// MARK: - Years (paginated)

struct LifeYearsPaginatedView: View {
    @EnvironmentObject private var appState: AppState
    @State private var page = 0

    private let pageSize = 12

    private var currentYear: Int {
        Calendar.current.component(.year, from: Date())
    }

    var body: some View {
        let _ = appState.dataRevision
        Group {
            if let profile = appState.profile {
                let years = Array(LifeMapData.yearRange(for: profile))
                let pages = stride(from: 0, to: years.count, by: pageSize).map { start in
                    Array(years[start..<min(start + pageSize, years.count)])
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        LifeProgressBlock(life: LifeProgress.fromProfile(profile))
                        LifeMapLegend()

                        if pages.count > 1 {
                            HStack {
                                Button {
                                    page = max(page - 1, 0)
                                } label: {
                                    Image(systemName: "chevron.left")
                                }
                                .disabled(page == 0)

                                Spacer()
                                Text("Стр. \(page + 1) из \(pages.count)")
                                    .font(.caption)
                                    .foregroundStyle(QadamTheme.textSecondary)
                                Spacer()

                                Button {
                                    page = min(page + 1, pages.count - 1)
                                } label: {
                                    Image(systemName: "chevron.right")
                                }
                                .disabled(page >= pages.count - 1)
                            }
                            .padding(.horizontal, 4)
                        }

                        Text("Выберите год")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(QadamTheme.textSecondary)

                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                            spacing: 12
                        ) {
                            ForEach(pages[safe: page] ?? [], id: \.self) { year in
                                NavigationLink(value: year) {
                                    yearTile(year: year, isCurrent: year == currentYear)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(20)
                }
                .onAppear {
                    if let idx = pages.firstIndex(where: { $0.contains(currentYear) }) {
                        page = idx
                    }
                }
            } else {
                Text("Нет профиля").padding()
            }
        }
        .background(QadamTheme.background)
        .navigationTitle("Все годы")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Int.self) { year in
            LifeYearView(year: year, showsYearsEntry: false)
        }
    }

    private func yearTile(year: Int, isCurrent: Bool) -> some View {
        let stats = appState.yearSummaries[year] ?? .empty

        return VStack(spacing: 6) {
            Text("\(year)")
                .font(.title3.bold())
                .foregroundStyle(isCurrent ? QadamTheme.gold : QadamTheme.textPrimary)
            if isCurrent {
                Text("сейчас")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(QadamTheme.primary)
            }
            if stats.hasData {
                Text(stats.label)
                    .font(.caption2)
                    .foregroundStyle(QadamTheme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(isCurrent ? QadamTheme.gold.opacity(0.12) : QadamTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(isCurrent ? QadamTheme.gold.opacity(0.5) : QadamTheme.cardBorder, lineWidth: 1)
        }
    }
}

// MARK: - Year → Months (уровень 2)

struct LifeYearView: View {
    @EnvironmentObject private var appState: AppState
    let year: Int
    var showsYearsEntry = false

    private var currentYear: Int { Calendar.current.component(.year, from: Date()) }
    private var currentMonth: Int { Calendar.current.component(.month, from: Date()) }

    var body: some View {
        let _ = appState.dataRevision
        ScrollView {
            if let profile = appState.profile {
                let months = LifeMapData.months(
                    profile: profile,
                    year: year,
                    weekStatuses: appState.weekStatuses
                )

                VStack(alignment: .leading, spacing: 16) {
                    if year == currentYear {
                        LifeProgressBlock(life: LifeProgress.fromProfile(profile))
                    }

                    LifeMapLegend()

                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)],
                        spacing: 14
                    ) {
                        ForEach(months, id: \.month) { month in
                            let isCurrent = year == currentYear && month.month == currentMonth
                            NavigationLink(value: LifeMonthRoute(year: year, month: month.month)) {
                                monthTile(month, isCurrent: isCurrent)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(20)
            }
        }
        .background(QadamTheme.background)
        .navigationTitle("\(year)")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if showsYearsEntry {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: LifeYearsRoute()) {
                        Text("Годы")
                            .font(.subheadline.weight(.semibold))
                    }
                }
            }
        }
        .navigationDestination(for: LifeMonthRoute.self) { route in
            LifeMonthView(year: route.year, month: route.month)
        }
    }

    private func monthTile(_ month: LifeMonthSection, isCurrent: Bool) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(month.shortTitle)
                    .font(.headline)
                    .foregroundStyle(isCurrent ? QadamTheme.gold : QadamTheme.textPrimary)
                Spacer()
                if !month.weeks.isEmpty {
                    Text(month.statsLabel)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(QadamTheme.textSecondary)
                }
            }

            if isCurrent {
                Text("сейчас")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(QadamTheme.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(QadamTheme.gold.opacity(0.2))
                    .clipShape(Capsule())
            }

            if month.weeks.isEmpty {
                Text("—")
                    .foregroundStyle(QadamTheme.textSecondary)
                    .frame(maxWidth: .infinity, minHeight: 48)
            } else {
                VStack(spacing: 6) {
                    ForEach(month.weeks, id: \.weekIndex) { week in
                        HStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(LifeMapData.color(for: week.status))
                                .frame(width: 28, height: 10)
                            Text(LifeWeekUtils.formatShortDate(week.weekStart))
                                .font(.caption2)
                                .foregroundStyle(QadamTheme.textSecondary)
                                .lineLimit(1)
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
        .background(isCurrent ? QadamTheme.gold.opacity(0.1) : QadamTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(isCurrent ? QadamTheme.gold.opacity(0.45) : QadamTheme.cardBorder, lineWidth: 1)
        }
    }
}

// MARK: - Month → Weeks (уровень 3)

struct LifeMonthView: View {
    @EnvironmentObject private var appState: AppState
    let year: Int
    let month: Int

    @State private var weekPage = 0

    var body: some View {
        let _ = appState.dataRevision
        Group {
            if let profile = appState.profile {
                let months = LifeMapData.months(
                    profile: profile,
                    year: year,
                    weekStatuses: appState.weekStatuses
                )
                let section = months.first { $0.month == month }
                let weeks = section?.weeks ?? []

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if weeks.isEmpty {
                            Text("В этом месяце нет недель жизни")
                                .foregroundStyle(QadamTheme.textSecondary)
                                .padding()
                        } else {
                            Text("Листай недели")
                                .font(.caption)
                                .foregroundStyle(QadamTheme.textSecondary)
                                .padding(.horizontal, 20)

                            TabView(selection: $weekPage) {
                                ForEach(Array(weeks.enumerated()), id: \.element.weekIndex) { index, week in
                                    weekSwipeCard(week, profile: profile)
                                        .padding(.horizontal, 20)
                                        .tag(index)
                                }
                            }
                            .tabViewStyle(.page(indexDisplayMode: .automatic))
                            .frame(height: 220)

                            Text("Все недели")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(QadamTheme.textSecondary)
                                .padding(.horizontal, 20)

                            VStack(spacing: 10) {
                                ForEach(weeks, id: \.weekIndex) { week in
                                    NavigationLink {
                                        WeekDetailView(weekIndex: week.weekIndex)
                                    } label: {
                                        weekListRow(week, profile: profile)
                                    }
                                    .buttonStyle(.plain)
                                    .disabled(week.status == .future)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.vertical, 16)
                }
                .onAppear {
                    if let current = weeks.firstIndex(where: { $0.status == .current }) {
                        weekPage = current
                    }
                }
            }
        }
        .background(QadamTheme.background)
        .navigationTitle(LifeMapData.monthTitle(year: year, month: month))
        .navigationBarTitleDisplayMode(.inline)
    }

    private func weekSwipeCard(_ week: LifeWeekEntry, profile: UserProfile) -> some View {
        let end = LifeWeekUtils.weekEndForIndex(birthDate: profile.birthDate, weekIndex: week.weekIndex)
        return NavigationLink {
            WeekDetailView(weekIndex: week.weekIndex)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Неделя \(week.weekIndex + 1)")
                        .font(.title2.bold())
                    Spacer()
                    Circle()
                        .fill(LifeMapData.color(for: week.status))
                        .frame(width: 16, height: 16)
                }
                Text("\(LifeWeekUtils.formatShortDate(week.weekStart)) – \(LifeWeekUtils.formatShortDate(end))")
                    .font(.subheadline)
                    .foregroundStyle(QadamTheme.textSecondary)
                Text(week.status.label)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(QadamTheme.gold)
                Text("Нажми, чтобы открыть дни →")
                    .font(.caption)
                    .foregroundStyle(QadamTheme.textSecondary)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(QadamTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(LifeMapData.color(for: week.status).opacity(0.4), lineWidth: 2)
            }
        }
        .buttonStyle(.plain)
        .disabled(week.status == .future)
    }

    private func weekListRow(_ week: LifeWeekEntry, profile: UserProfile) -> some View {
        let end = LifeWeekUtils.weekEndForIndex(birthDate: profile.birthDate, weekIndex: week.weekIndex)
        return HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 6)
                .fill(LifeMapData.color(for: week.status))
                .frame(width: 44, height: 44)
            VStack(alignment: .leading, spacing: 4) {
                Text("Неделя \(week.weekIndex + 1)")
                    .font(.headline)
                Text("\(LifeWeekUtils.formatShortDate(week.weekStart)) – \(LifeWeekUtils.formatShortDate(end))")
                    .font(.caption)
                    .foregroundStyle(QadamTheme.textSecondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(QadamTheme.textSecondary)
        }
        .padding(14)
        .background(QadamTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14).stroke(QadamTheme.cardBorder, lineWidth: 1)
        }
        .opacity(week.status == .future ? 0.45 : 1)
    }
}

// MARK: - Shared

struct LifeMonthRoute: Hashable {
    let year: Int
    let month: Int
}

struct LifeWeekEntry: Hashable {
    let weekIndex: Int
    let status: WeekStatus
    let weekStart: Date
}

struct LifeMonthSection: Hashable {
    let month: Int
    let shortTitle: String
    let weeks: [LifeWeekEntry]

    var statsLabel: String {
        let g = weeks.filter { $0.status == .green }.count
        let y = weeks.filter { $0.status == .yellow }.count
        let r = weeks.filter { $0.status == .red }.count
        return "\(g)·\(y)·\(r)"
    }
}

struct LifeYearSummary: Hashable {
    let green: Int
    let yellow: Int
    let red: Int

    static let empty = LifeYearSummary(green: 0, yellow: 0, red: 0)

    var hasData: Bool { green + yellow + red > 0 }

    var label: String { "\(green)·\(yellow)·\(red)" }
}

enum LifeMapData {
    static func yearRange(for profile: UserProfile) -> ClosedRange<Int> {
        profile.birthDate.year...(profile.birthDate.year + profile.lifeExpectancy)
    }

    static func yearSummaries(profile: UserProfile, weekStatuses: [WeekStatus]) -> [Int: LifeYearSummary] {
        var result: [Int: LifeYearSummary] = [:]
        let birth = profile.birthDate

        for (weekIndex, status) in weekStatuses.enumerated() {
            let weekStart = LifeWeekUtils.weekStartForIndex(birthDate: birth, weekIndex: weekIndex)
            let year = Calendar.current.component(.year, from: weekStart)
            var current = result[year] ?? .empty

            switch status {
            case .green:
                current = LifeYearSummary(green: current.green + 1, yellow: current.yellow, red: current.red)
            case .yellow:
                current = LifeYearSummary(green: current.green, yellow: current.yellow + 1, red: current.red)
            case .red:
                current = LifeYearSummary(green: current.green, yellow: current.yellow, red: current.red + 1)
            default:
                break
            }
            result[year] = current
        }
        return result
    }

    static func monthTitle(year: Int, month: Int) -> String {
        LifeWeekUtils.formatMonthYear(year: year, month: month)
    }

    static func months(profile: UserProfile, year: Int, weekStatuses: [WeekStatus]) -> [LifeMonthSection] {
        var buckets: [Int: [LifeWeekEntry]] = Dictionary(uniqueKeysWithValues: (1...12).map { ($0, []) })
        let birth = profile.birthDate

        for weekIndex in 0..<weekStatuses.count {
            let weekStart = LifeWeekUtils.weekStartForIndex(birthDate: birth, weekIndex: weekIndex)
            guard Calendar.current.component(.year, from: weekStart) == year else { continue }
            let m = Calendar.current.component(.month, from: weekStart)
            buckets[m, default: []].append(LifeWeekEntry(
                weekIndex: weekIndex,
                status: weekStatuses[weekIndex],
                weekStart: weekStart
            ))
        }

        return (1...12).map { month in
            LifeMonthSection(
                month: month,
                shortTitle: shortMonthName(month),
                weeks: buckets[month] ?? []
            )
        }
    }

    static func color(for status: WeekStatus) -> Color {
        switch status {
        case .green: return QadamTheme.weekGreen
        case .yellow: return QadamTheme.weekYellow
        case .red: return QadamTheme.weekRed
        case .current: return QadamTheme.weekCurrent
        case .future: return QadamTheme.weekFuture
        case .empty: return QadamTheme.weekEmpty
        }
    }

    private static func shortMonthName(_ month: Int) -> String {
        var comps = DateComponents()
        comps.month = month
        comps.day = 1
        guard let date = Calendar.current.date(from: comps) else { return "\(month)" }
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.dateFormat = "LLLL"
        let raw = f.string(from: date)
        return raw.prefix(1).uppercased() + raw.dropFirst()
    }
}

struct LifeMapLegend: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                legendItem("Хорошо", QadamTheme.weekGreen)
                legendItem("Қаза", QadamTheme.weekYellow)
                legendItem("Пропуск", QadamTheme.weekRed)
                legendItem("Сейчас", QadamTheme.weekCurrent)
                legendItem("Будущее", QadamTheme.weekFuture)
            }
        }
    }

    private func legendItem(_ label: String, _ color: Color) -> some View {
        HStack(spacing: 5) {
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: 12, height: 12)
            Text(label)
                .font(.caption2)
                .foregroundStyle(QadamTheme.textSecondary)
        }
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

private extension Date {
    var year: Int { Calendar.current.component(.year, from: self) }
}
