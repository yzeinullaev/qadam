import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState

    @State private var step = 0
    @State private var name = ""
    @State private var birthDate = Calendar.current.date(from: DateComponents(year: 1990, month: 1, day: 1)) ?? Date()
    @State private var lifeExpectancy = 80
    @State private var city = ""
    @State private var useGeolocation = true
    @State private var priorWeeksMoodScore = 3
    @State private var startedPraying = false
    @State private var prayerPracticeStartDate = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
    @State private var saving = false
    @State private var locating = false
    @State private var errorMessage: String?

    private let stepCount = 4

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ProgressView(value: Double(step + 1), total: Double(stepCount))
                    .tint(QadamTheme.primary)
                    .padding(.horizontal)

                TabView(selection: $step) {
                    profileStep.tag(0)
                    locationStep.tag(1)
                    prayerJourneyStep.tag(2)
                    readyStep.tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: step)

                HStack {
                    if step > 0 {
                        Button("Назад") { step -= 1 }
                            .disabled(saving)
                    }
                    Spacer()
                    Button(step == stepCount - 1 ? "Начать" : "Далее") {
                        Task { await next() }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(QadamTheme.primary)
                    .disabled(saving)
                }
                .padding()
            }
            .background(QadamTheme.background)
            .navigationTitle(AppConstants.appName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text(AppConstants.appName).font(.headline)
                        Text(AppConstants.appSubtitle).font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
            .alert("Ошибка", isPresented: .constant(errorMessage != nil)) {
                Button("OK") { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }

    private var profileStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Добро пожаловать").font(.title2.bold())
                Text("Расскажи немного о себе — это основа карты жизни")
                    .foregroundStyle(QadamTheme.textSecondary)

                TextField("Имя", text: $name)
                    .textFieldStyle(.roundedBorder)

                DatePicker("Дата рождения", selection: $birthDate, in: ...Date(), displayedComponents: .date)

                Text("Ожидаемый возраст").font(.subheadline.bold())
                Picker("Возраст", selection: $lifeExpectancy) {
                    ForEach(AppConstants.lifeExpectancyOptions, id: \.self) { age in
                        Text("\(age)").tag(age)
                    }
                }
                .pickerStyle(.segmented)

                TextField("Город", text: $city)
                    .textFieldStyle(.roundedBorder)
                    .disabled(useGeolocation && appState.detectedCity != nil)
            }
            .padding(24)
        }
    }

    private var locationStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Геолокация").font(.title2.bold())
                Text("Определим ваш город и покажем точное время намаза.")
                    .foregroundStyle(QadamTheme.textSecondary)

                Toggle("Использовать геолокацию", isOn: $useGeolocation)

                if useGeolocation {
                    Button {
                        Task { await detectCity() }
                    } label: {
                        HStack {
                            if locating { ProgressView() }
                            else { Image(systemName: "location.fill") }
                            Text(locating ? "Определяем..." : "Определить где я")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(QadamTheme.primary)

                    if let detected = appState.detectedCity ?? appState.locationService.cityName {
                        Text("📍 \(detected)")
                            .font(.subheadline)
                            .foregroundStyle(QadamTheme.primary)
                    }
                } else {
                    TextField("Город", text: $city)
                        .textFieldStyle(.roundedBorder)
                }
            }
            .padding(24)
        }
    }

    private func detectCity() async {
        locating = true
        defer { locating = false }
        let result = await appState.locationService.requestLocation()
        if let name = result.city {
            city = name
            appState.detectedCity = name
        }
    }

    private var readyStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Твой путь").font(.title2.bold())
                Text("В MVP отслеживаем только главное:")
                    .foregroundStyle(QadamTheme.textSecondary)

                readyItem("🕌", "5 намазов + қаза")
                readyItem("📖", "Коран")
                readyItem("🤲", "Садака")
                readyItem("😊", "Настроение")
                readyItem("🗺", "Карта жизни")

                Text("Остальное — позже, когда привыкнешь к ритму.")
                    .foregroundStyle(QadamTheme.textSecondary)
            }
            .padding(24)
        }
    }

    private var prayerJourneyStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Твоя духовная динамика").font(.title2.bold())
                Text("Это поможет корректнее считать статистику и показывать путь в намазе.")
                    .foregroundStyle(QadamTheme.textSecondary)

                Text("Как бы оценили прошлые недели жизни?")
                    .font(.subheadline.bold())
                Picker("Оценка прошлых недель", selection: $priorWeeksMoodScore) {
                    Text("A").tag(5)
                    Text("B+").tag(4)
                    Text("B").tag(3)
                    Text("C+").tag(2)
                    Text("C").tag(1)
                }
                .pickerStyle(.segmented)

                Toggle("Я уже читаю намаз", isOn: $startedPraying)

                if startedPraying {
                    DatePicker(
                        "С какого времени читаете намаз",
                        selection: $prayerPracticeStartDate,
                        in: birthDate...Date(),
                        displayedComponents: .date
                    )
                }
            }
            .padding(24)
        }
    }

    private func readyItem(_ emoji: String, _ label: String) -> some View {
        HStack(spacing: 12) {
            Text(emoji).font(.title2)
            Text(label)
        }
    }

    private func next() async {
        if step < stepCount - 1 {
            guard validateStep() else { return }
            step += 1
            return
        }
        await finish()
    }

    private func validateStep() -> Bool {
        if step == 0 {
            if name.trimmingCharacters(in: .whitespaces).isEmpty {
                errorMessage = "Введите имя"
                return false
            }
            if city.trimmingCharacters(in: .whitespaces).isEmpty && !useGeolocation {
                errorMessage = "Введите город"
                return false
            }
        }
        return true
    }

    private func finish() async {
        guard validateStep() else { return }
        saving = true
        defer { saving = false }
        await appState.completeOnboarding(
            name: name.trimmingCharacters(in: .whitespaces),
            birthDate: birthDate,
            lifeExpectancy: lifeExpectancy,
            city: city.trimmingCharacters(in: .whitespaces).isEmpty ? (appState.detectedCity ?? "Алматы") : city.trimmingCharacters(in: .whitespaces),
            useGeolocation: useGeolocation,
            priorWeeksMoodScore: priorWeeksMoodScore,
            prayerPracticeStartDate: startedPraying ? prayerPracticeStartDate : nil
        )
    }
}
