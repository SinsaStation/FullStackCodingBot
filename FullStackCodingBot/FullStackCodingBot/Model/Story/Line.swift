import Foundation

struct Line {
    let text: String
    let emotion: Emotion?
    
    enum Emotion {
        case love
        case happy
        case normal
        case notGood
        case bad
        case angry
        
        var imageTag: String {
            switch self {
            case .love:
                return "_love"
            case .happy:
                return "_happy"
            case .normal:
                return "_normal"
            case .notGood:
                return "_bad"
            case .bad:
                return "_bad2"
            case .angry:
                return "_angry"
            }
        }
    }
    
    let special: Special?
    
    enum Special {
        case intro
        case outro
        
        var imageTag: String {
            switch self {
            case .intro:
                return "intro"
            case .outro:
                return "outro"
            }
        }
    }
    
    init(text: String, emotion: Emotion? = nil, special: Special? = nil) {
        self.text = text
        self.emotion = emotion
        self.special = special
    }
}
