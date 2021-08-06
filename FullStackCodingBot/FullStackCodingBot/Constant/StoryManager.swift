import Foundation

enum StoryManager: CaseIterable {
    case firstLine
    case secondLine
    case thirdLine
    case fourthLine
    case fifthLine
    case sixthLine
    case seventhLine
    
    var content: (name: String, script: String) {
        switch self {
        case .firstLine:
            return ("디버그", "프로젝트 마무리 됐습니다.")
        case .secondLine:
            return ("버그", "여기 수정하게, 여기도, 여기도, 여기도 …")
        case .thirdLine:
            return ("디버그", "저 사장님! \n모바일, 프론트 개발자들이 퇴사해서 이 부분은 제가 수정하기 어려울 거 같습니다.")
        case .fourthLine:
            return ("버그", "무슨 소리야? \n자네도 개발자 아닌가? 사람 곧 뽑아 줄테니 어서 시작하게")
        case .fifthLine:
            return ("디버그", "…")
        case .sixthLine:
            return ("버그", "뭐하고 있나? 어서 나가서 시작하게")
        case .seventhLine:
            return ("디버그", "!!!!!!!")
        }
    }
}
