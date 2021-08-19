import Foundation

struct ErrorMessage {
    let title: String
    let content: String
}

enum AlertMessage {
    case networkLoad
    case versionUpdate
    
    var content: (message: ErrorMessage, confirm: String) {
        switch self {
        case .networkLoad:
            let errorMessage = ErrorMessage(title: "NetworkError",
                                            content: "데이터를 가져오는데 실패했습니다.")
            return (errorMessage, "확인")
        
        case .versionUpdate:
            let errorMessage = ErrorMessage(title: "", content: "원활한 게임 진행을 위해 업데이트가 필요합니다.")
            return (errorMessage, "확인")
        }
    }
}
