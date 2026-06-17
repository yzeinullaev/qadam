import SwiftUI

enum QadamTheme {
    // Forest green + gold palette from brand icon
    static let primary = Color(red: 0.12, green: 0.32, blue: 0.22)
    static let primaryLight = Color(red: 0.18, green: 0.42, blue: 0.30)
    static let gold = Color(red: 0.79, green: 0.66, blue: 0.38)
    static let goldLight = Color(red: 0.92, green: 0.84, blue: 0.65)
    static let background = Color(red: 0.97, green: 0.96, blue: 0.93)
    static let surface = Color(red: 1.0, green: 0.99, blue: 0.97)
    static let surfaceElevated = Color(red: 0.14, green: 0.28, blue: 0.20)
    static let textPrimary = Color(red: 0.10, green: 0.14, blue: 0.12)
    static let textSecondary = Color(red: 0.42, green: 0.44, blue: 0.40)
    static let textOnDark = Color(red: 0.96, green: 0.95, blue: 0.91)
    static let weekGreen = Color(red: 0.22, green: 0.55, blue: 0.36)
    static let weekYellow = gold
    static let weekRed = Color(red: 0.75, green: 0.28, blue: 0.28)
    static let weekCurrent = Color(red: 0.20, green: 0.45, blue: 0.62)
    static let weekFuture = Color(red: 0.88, green: 0.86, blue: 0.82)
    static let weekEmpty = Color(red: 0.82, green: 0.80, blue: 0.76)
    static let cardBorder = Color(red: 0.85, green: 0.82, blue: 0.74)
    static let sectionHeader = gold

    static var heroGradient: LinearGradient {
        LinearGradient(
            colors: [primary, primaryLight],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct QadamCard<Content: View>: View {
    var elevated = false
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(14)
            .background(elevated ? QadamTheme.surfaceElevated : QadamTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(elevated ? QadamTheme.gold.opacity(0.35) : QadamTheme.cardBorder, lineWidth: 1)
            )
            .shadow(color: QadamTheme.primary.opacity(elevated ? 0.15 : 0.06), radius: elevated ? 8 : 4, y: 2)
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(QadamTheme.gold)
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(QadamTheme.primary)
        }
    }
}
