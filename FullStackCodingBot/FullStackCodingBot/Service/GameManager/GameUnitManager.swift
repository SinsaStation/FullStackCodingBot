import Foundation

struct StackMemberUnit {
    let content: Unit
    let order: Int
    let direction: Direction
}

final class GameUnitManager: GameUnitManagerType {
    
    private var allKinds: [Unit]
    private var unused: [Unit]
    private var leftStack: [Unit]
    private var rightStack: [Unit]
    private(set) var onGames: [Unit]
    private var memberCount: Int
    private var answerCount: Int
    
    init(allKinds: [Unit], unused: [Unit] = [], leftStack: [Unit] = [], rightStack: [Unit] = [], onGames: [Unit] = [], memberCount: Int = 0, answerCount: Int = 0) {
        self.allKinds = allKinds
        self.unused = unused
        self.leftStack = leftStack
        self.rightStack = rightStack
        self.onGames = onGames
        self.memberCount = memberCount
        self.answerCount = answerCount
    }
    
    func resetAll() {
        unused = allKinds.shuffled()
        leftStack.removeAll()
        rightStack.removeAll()
        onGames.removeAll()
        memberCount = .zero
        answerCount = .zero
    }
    
    func startings() -> [Unit] {
        let unitsToUse = leftStack + rightStack
        generateNewUnit(from: unitsToUse, count: GameSetting.count)
        return onGames
    }
    
    func removeAndRefilled() -> [Unit] {
        guard !onGames.isEmpty else { return [] }
        onGames.removeFirst()
        
        let unitsToUse = leftStack + rightStack
        generateNewUnit(from: unitsToUse, count: 1)
        
        return onGames
    }
    
    private func generateNewUnit(from stack: [Unit], count: Int) {
        guard let firstUnit = stack.first else { return }
        
        (0..<count).forEach { _ in
            let newUnit = stack.randomElement() ?? firstUnit
            onGames.append(newUnit)
        }
    }
    
    func isMoveActionCorrect(to direction: Direction) -> Bool {
        guard let currentUnit = onGames.first else { return false }
        
        switch direction {
        case .left:
            return leftStack.contains(currentUnit)
        case .right:
            return rightStack.contains(currentUnit)
        }
    }
    
    func currentHeadUnitScore() -> Int? {
        guard let headUnit = onGames.first else { return nil }
        return headUnit.score()
    }
    
    func raiseAnswerCount() {
        self.answerCount += 1
    }
    
    func isTimeToLevelUp() -> Bool {
        
        guard memberCount < GameSetting.maxUnitCount else { return false }
        
        switch memberCount {
        case 2:
            return answerCount >= memberCount * 20
        case 3:
            return answerCount >= memberCount * 30
        case 4:
            return answerCount >= memberCount * 50
        default:
            return answerCount >= memberCount * 60
        }
    }
    
    func newMember() -> StackMemberUnit {
        let newUnit = unused.removeLast()
        memberCount += 1
        
        switch memberCount % 2 == 0 {
        
        case true:
            leftStack.append(newUnit)
            return StackMemberUnit(content: newUnit, order: leftStack.count-1, direction: .left)
        case false:
            rightStack.append(newUnit)
            return StackMemberUnit(content: newUnit, order: rightStack.count-1, direction: .right)
        }
    }
}
