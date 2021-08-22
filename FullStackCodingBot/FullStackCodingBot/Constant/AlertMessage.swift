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
            let errorMessage = ErrorMessage(title: "Internet Connection Recommended",
                                            content: "본 게임은 오프라인 플레이를 지원합니다.\n그러나 안전한 데이터 백업 및 랭킹 등록, 리워드 수령을 위해서는 인터넷 연결이 필요합니다!")
            return (errorMessage, "확인")
        
        case .versionUpdate:
            let errorMessage = ErrorMessage(title: "", content: "원활한 게임 진행을 위해 업데이트가 필요합니다.")
            return (errorMessage, "확인")
        }
    }
}
