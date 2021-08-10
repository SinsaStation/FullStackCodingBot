import Foundation

struct ErrorMessage {
    let title: String
    let content: String
}

enum AlertMessage {
    case networkLoad
    
    var content: (message: ErrorMessage, confirm: String) {
        switch self {
        case .networkLoad:
            let errorMessage = ErrorMessage(title: "NetworkError",
                                            content: "데이터를 가져오는데 실패했습니다.")
            return (errorMessage, "확인")
        }
    }
}
