import Foundation

enum AlertMessage {
    case levelUp
    
    // swiftlint:disable:next large_tuple
    var content: (title: String, content: String, confirm: String) {
        switch self {
        case .levelUp:
            return ("돈 부족", "레벨업에 필요한 돈이 부족합니다.", "확인")
        }
    }
}
