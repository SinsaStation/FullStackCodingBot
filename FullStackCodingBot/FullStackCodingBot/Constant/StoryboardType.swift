import Foundation

enum StoryboardType {
    case main
    case game
    
    var name: String {
        switch self {
        case .main:
            return "Main"
        case .game:
            return "Game"
        }
    }
}
