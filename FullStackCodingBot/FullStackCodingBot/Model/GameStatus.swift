import Foundation

enum LevelUpStatus {
    case success(Unit)
    case fail(Int)
    case info
}

enum GameStatus {
    case ready
    case new
    case pause
    case resume
}

enum UserActionStatus {
    case correct(Direction)
    case wrong
    case feverWrong
}
