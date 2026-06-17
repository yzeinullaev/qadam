import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState

    @State private var name = ""
    @State private var city = ""
    @State private var useGeolocation = true
    @State private var calculationMethod = AppConstants.calculationMethods[0]
    @State private var asrMadhab = AppConstants.asrMadhabOptions[0]
    @State private var priorWeeksMoodScore = 3
    @State private var startedPraying = false
    @State private var prayerPracticeStartDate = Date()
    @State private var saved = false
    @State private var locating = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Профиль") {
                    TextField("Имя", text: $name)
                    TextField("Город", text: $city)
                    Toggle("Геолокация", isOn: $useGeolocation)
                        .onChange(of: useGeolocation) { enabled in
                            if enabled { Task { await detectLocation() } }
                        }

                    if useGeolocation {
                        Button {
                            Task { await detectLocation() }
                        } label: {
                            HStack {
                                if locating {
                                    ProgressView()
                                } else {
                                    Image(systemName: "location.fill")
                                }
                                Text(locating ? "Определяем..." : "Определить моё местоположение")
                            }
                        }
                        .disabled(locating)

                        if let detected = appState.detectedCity ?? appState.locationService.cityName {
                            Text("Сейчас: \(detected)")
                                .font(.caption)
                                .foregroundStyle(QadamTheme.primary)
                        }
                    }
                }

                Section("Привычки") {
                    ForEach(appState.habitSettings) { habit in
                        Toggle(habit.title, isOn: Binding(
                            get: { habit.isActive },
                            set: { appState.setHabitActive(key: habit.habitKey, isActive: $0) }
                        ))
                    }
                }

                Section("Намаз") {
                    Picker("Метод расчёта", selection: $calculationMethod) {
                        ForEach(AppConstants.calculationMethods, id: \.self) { method in
                            Text(method).tag(method)
                        }
                    }
                    Picker("Аср", selection: $asrMadhab) {
                        ForEach(AppConstants.asrMadhabOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                }

                Section("Духовный путь") {
                    Picker("Оценка прошлых недель", selection: $priorWeeksMoodScore) {
                        Text("A").tag(5)
                        Text("B+").tag(4)
                        Text("B").tag(3)
                        Text("C+").tag(2)
                        Text("C").tag(1)
                    }
                    .pickerStyle(.segmented)

                    Toggle("Я читаю намаз", isOn: $startedPraying)
                    if startedPraying {
                        DatePicker("Дата начала намаза", selection: $prayerPracticeStartDate, in: ...Date(), displayedComponents: .date)
                    }
                }

                Section {
                    Button("Сохранить") { save() }
                }
            }
            .scrollContentBackground(.hidden)
            .background(QadamTheme.background)
            .navigationTitle("Настройки")
            .onAppear { loadFromProfile() }
            .alert("Сохранено", isPresented: $saved) {
                Button("OK", role: .cancel) {}
            }
        }
    }

    private func detectLocation() async {
        locating = true
        defer { locating = false }
        await appState.refreshLocation()
        if let city = appState.profile?.city {
            self.city = city
        }
    }

    private func loadFromProfile() {
        guard let profile = appState.profile else { return }
        name = profile.name
        city = profile.city
        useGeolocation = profile.useGeolocation
        calculationMethod = profile.calculationMethod
        asrMadhab = profile.asrMadhab
        priorWeeksMoodScore = profile.priorWeeksMoodScore ?? 3
        startedPraying = profile.prayerPracticeStartDate != nil
        prayerPracticeStartDate = profile.prayerPracticeStartDate ?? Date()
    }

    private func save() {
        guard var profile = appState.profile else { return }
        profile.name = name.trimmingCharacters(in: .whitespaces)
        profile.city = city.trimmingCharacters(in: .whitespaces)
        profile.useGeolocation = useGeolocation
        profile.calculationMethod = calculationMethod
        profile.asrMadhab = asrMadhab
        profile.priorWeeksMoodScore = priorWeeksMoodScore
        profile.prayerPracticeStartDate = startedPraying ? prayerPracticeStartDate : nil

        if !useGeolocation {
            let coords = CityCoordinates.forCity(city)
            profile.latitude = coords.lat
            profile.longitude = coords.lng
        }

        appState.updateProfile(profile)
        if useGeolocation {
            Task { await appState.refreshLocation() }
        }
        saved = true
    }
}
