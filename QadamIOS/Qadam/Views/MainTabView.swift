import SwiftUI

struct MainTabView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(QadamTheme.surface)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Путь", systemImage: "sun.max.fill") }

            LifeMapView()
                .tabItem { Label("Жизнь", systemImage: "map.fill") }

            StatsView()
                .tabItem { Label("Статистика", systemImage: "chart.bar.fill") }

            SettingsView()
                .tabItem { Label("Настройки", systemImage: "gearshape.fill") }
        }
        .tint(QadamTheme.primary)
    }
}
