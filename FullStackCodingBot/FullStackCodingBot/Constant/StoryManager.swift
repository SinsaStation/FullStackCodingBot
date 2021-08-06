import Foundation

enum StoryManager: CaseIterable {
    case setting
    case firstLine
    case secondLine
    case thirdLine
    case fourthLine
    case fifthLine
    case sixthLine
    case seventhLine
    
    var content: (name: String, script: String) {
        switch self {
        case .setting:
            return ("나레이션", "00네트웍스 8년차 개발자 김디버그\n프로젝트 보고를 위해 왕버그 대표를 찾아간다.")
        case .firstLine:
            return ("김디버그", "프로젝트 마무리 됐습니다.")
        case .secondLine:
            return ("왕버그", "여기 수정하게, 여기도, 여기도, 여기도 …")
        case .thirdLine:
            return ("김디버그", "저 사장님! \n모바일, 프론트 개발자들이 퇴사해서 이 부분은 제가 수정하기 어려울 거 같습니다.")
        case .fourthLine:
            return ("왕버그", "무슨 소리야? \n자네도 개발자 아닌가? 사람 곧 뽑아 줄테니 어서 시작하게")
        case .fifthLine:
            return ("김디버그", "…")
        case .sixthLine:
            return ("왕버그", "뭐하고 있나? 어서 나가서 시작하게")
        case .seventhLine:
            return ("김디버그", "(으아아악!!!!!!!)")
        }
    }
}
