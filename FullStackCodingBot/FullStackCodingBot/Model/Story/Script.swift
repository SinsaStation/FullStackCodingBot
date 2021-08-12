import Foundation

struct Script {
    
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
    
    func runTime() -> Double {
        let wordCount = line.count
        let runTime = 1.7 + Double(wordCount) * 0.075
        return runTime
    }
}

extension Script {
    static let story: [Script] = [
        .init(line: .init(text: "IT 중소기업 \'No Yeah Tech\'", special: .intro), animation: .zoom),
        .init(speaker: .worker, line: .init(text: "프로젝트 마무리됐습니다", emotion: .normal)),
        .init(speaker: .ceo, line: .init(text: "(검토...)", emotion: .normal)),
        .init(speaker: .ceo, line: .init(text: "여기 수정하게.\n여기도, 여기도, 여기도...", emotion: .notGood)),
        .init(speaker: .worker, line: .init(text: "저 그런데...\n프론트 개발자들이 퇴사를 해서", emotion: .normal)),
        .init(speaker: .worker, line: .init(text: "이 부분은 수정이 불가능할 것 같은데요", emotion: .notGood)),
        .init(speaker: .ceo, line: .init(text: "무슨 소리야?\n자네는 개발자 아닌가?", emotion: .bad)),
        .init(speaker: .worker, line: .init(text: "(...)", emotion: .bad)),
        .init(speaker: .ceo, line: .init(text: "뭐하고 있나?\n어서 나가서 일하지 않고", emotion: .notGood)),
        .init(line: .init(text: "으아아아아아악!!!", special: .outro), animation: .shake)
    ]
    
    enum Game {
        static let bad: [Script] = [
            .init(speaker: .ceo, line: .init(text: "이게 뭔가,\n월급 받기 싫은가?", emotion: .notGood)),
            .init(speaker: .ceo, line: .init(text: "좀 더 제대로 할 수 없나?\n쯧...", emotion: .notGood)),
            .init(speaker: .ceo, line: .init(text: "아직 멀었군.\n내일도 야근하게.", emotion: .notGood)),
            .init(speaker: .worker, line: .init(text: "아..\n역시 안 되는 건가", emotion: .notGood)),
            .init(speaker: .worker, line: .init(text: "피곤하다.\n집에 가고 싶어...", emotion: .notGood))
        ]
        
        static let soso: [Script] = [
            .init(speaker: .ceo, line: .init(text: "더 노력하게.\n아직 많이 부족해.", emotion: .normal)),
            .init(speaker: .ceo, line: .init(text: "나쁘지 않네만...\n연봉 인상은 어렵겠군", emotion: .normal)),
            .init(speaker: .ceo, line: .init(text: "오늘은 10시엔 집에갈 수 있겠구만", emotion: .normal)),
            .init(speaker: .worker, line: .init(text: "그래도 희망이 보이는 것 같아", emotion: .normal)),
            .init(speaker: .worker, line: .init(text: "이대로만 하면 괜찮을 지도?", emotion: .normal)),
            .init(speaker: .worker, line: .init(text: "이제 퇴근해도 될 것 같다!\n...어랏 막차가 끊겼네?", emotion: .normal))
        ]
        
        static let good: [Script] = [
            .init(speaker: .ceo, line: .init(text: "좋아,\n연봉 인상 고려해보지!", emotion: .happy)),
            .init(speaker: .ceo, line: .init(text: "역시 자네야!\n조금만 더 일하고 퇴근하게!", emotion: .happy)),
            .init(speaker: .ceo, line: .init(text: "오늘은 그만 퇴근하게.\n수고했네.", emotion: .happy)),
            .init(speaker: .worker, line: .init(text: "퇴근하자!\n아직 8시 밖에 안 됐어!", emotion: .happy)),
            .init(speaker: .worker, line: .init(text: "나 좀 잘하는데?\n이러다 정말 마스터하겠어", emotion: .happy))
        ]
        
        static let great: [Script] = [
            .init(speaker: .ceo, line: .init(text: "훌륭하군!\n내년 연봉은 기대하게.", emotion: .love)),
            .init(speaker: .ceo, line: .init(text: "혼자서도 되지 않는가?\n역시 개발자 채용은 필요없겠군.\n허허허", emotion: .love)),
            .init(speaker: .ceo, line: .init(text: "아주 훌륭해!\n자네는 영원히 이 회사에서 일하게나!", emotion: .love)),
            .init(speaker: .worker, line: .init(text: "좋아!\n이 실력이라면 네카라쿠배도 무리 없어!", emotion: .happy)),
            .init(speaker: .worker, line: .init(text: "5시 퇴근이라니,\n기적 같은 일이야!", emotion: .happy)),
            .init(speaker: .worker, line: .init(text: "정말로 풀스택 마스터가 되어 버렸어..!", emotion: .happy))
        ]
    }
}
