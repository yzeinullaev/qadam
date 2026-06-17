import Foundation

enum DayStatus: String, Codable {
    case green
    case yellow
    case red
    case empty

    var label: String {
        switch self {
        case .green: return "Выполнено"
        case .yellow: return "Қаза закрыта"
        case .red: return "Пропуск"
        case .empty: return "Нет данных"
        }
    }
}

enum WeekStatus: String, Codable {
    case green
    case yellow
    case red
    case empty
    case future
    case current

    var label: String {
        switch self {
        case .green: return "Все намазы выполнены"
        case .yellow: return "Были пропуски, қаза закрыта"
        case .red: return "Есть незакрытая қаза"
        case .empty: return "Нет данных"
        case .future: return "Будущая неделя"
        case .current: return "Текущая неделя"
        }
    }
}
