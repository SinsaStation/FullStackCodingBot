import Foundation

struct GameStoryManager {
    
    private let scripts: [Rank: [Script]] = [.bad: Script.Game.bad,
                                             .soso: Script.Game.soso,
                                             .good: Script.Game.good,
                                             .great: Script.Game.great]
    
    private enum Rank {
        case bad
        case soso
        case good
        case great
        
        var character: String {
            switch self {
            case .bad:
                return "C"
            case .soso:
                return "B"
            case .good:
                return "A"
            case .great:
                return "S"
            }
        }
    }
    
    private func rank(for score: Int) -> Rank {
        switch score {
        case ..<2000:
            return .bad
        case 2000..<4000:
            return .soso
        case 4000..<7000:
            return .good
        default:
            return .great
        }
    }
    
    func rankCharacter(for score: Int) -> String {
        return rank(for: score).character
    }
    
    func randomScript(for score: Int) -> Script {
        let rank = rank(for: score)
        let scripts = self.scripts[rank]!
        let randomIndex = Int.random(in: 0..<scripts.count)
        return scripts[randomIndex]
    }
}
