import Foundation

struct Script {
    
    static let all: [Script] = [
        .init(line: .init(text: "\"Know Yeah Technology\"", special: .intro), animation: .zoom),
        .init(speaker: .worker, line: .init(text: "프로젝트 마무리 됐습니다", emotion: .normal)),
        .init(speaker: .ceo, line: .init(text: "(검토...)", emotion: .normal)),
        .init(speaker: .ceo, line: .init(text: "여기 수정하게.\n여기도, 여기도, 여기도...", emotion: .normal)),
        .init(speaker: .worker, line: .init(text: "저 그런데...\n프론트 개발자들이 퇴사를 해서", emotion: .normal)),
        .init(speaker: .worker, line: .init(text: "이 부분은 수정이 불가능 할 것 같은데...", emotion: .notGood)),
        .init(speaker: .ceo, line: .init(text: "무슨 소리야?\n자네도 개발자 아닌가?", emotion: .normal)),
        .init(speaker: .worker, line: .init(text: "(...)", emotion: .bad)),
        .init(speaker: .ceo, line: .init(text: "뭐하고 있나?\n어서 나가서 시작하게", emotion: .normal)),
        .init(line: .init(text: "으아아아아아악!!!", special: .outro), animation: .shake)
    ]
    
    let line: String
    let animation: Animation
    
    enum Animation {
        case fadeIn
        case shake
        case zoom
    }
    
    let speaker: Speaker?
    
    enum Speaker {
        case worker
        case ceo
        
        var info: (name: String, role: String) {
            switch self {
            case .worker:
                return ("김디버그", "/ 백엔드 개발자")
            case .ceo:
                return ("왕버그", "/ 사장")
            }
        }
        
        var imageName: String {
            switch self {
            case .worker:
                return "story_person"
            case .ceo:
                return "story_akduk"
            }
        }
    }
    
    let imageName: String?
    
    init(speaker: Speaker? = nil, line: Line, animation: Animation = .fadeIn) {
        self.speaker = speaker
        self.line = line.text
        self.animation = animation
        
        if let speakerTag = speaker?.imageName, let emotionTag = line.emotion?.imageTag {
            self.imageName = speakerTag + emotionTag
        } else {
            self.imageName = line.special?.imageTag
        }
    }
}
