import SwiftUI

@main
struct QadamApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .tint(QadamTheme.primary)
                .onAppear { appState.load() }
        }
    }
}

struct RootView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Group {
            if appState.isLoading {
                ProgressView()
            } else if appState.onboardingCompleted {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(QadamTheme.background)
    }
}
