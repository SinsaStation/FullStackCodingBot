import Foundation

struct StackMemberUnit {
    let content: Unit
    let order: Int
    let direction: Direction
}

final class GameUnitManager {
    
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
        generateNewUnit(from: unitsToUse, count: Perspective.count)
        return onGames
    }
    
    func removeAndRefilled() -> [Unit] {
        onGames.remove(at: 0)
        
        let unitsToUse = leftStack + rightStack
        generateNewUnit(from: unitsToUse, count: 1)
        
        return onGames
    }
    
    private func generateNewUnit(from stack: [Unit], count: Int) {
        (0..<count).forEach { _ in
            let newUnit = stack.randomElement() ?? stack[0]
            onGames.append(newUnit)
        }
    }
    
    func isMoveActionCorrect(to direction: Direction) -> Bool {
        let currentUnit = onGames[0]

        switch direction {
        case .left:
            return leftStack.contains(currentUnit)
        case .right:
            return rightStack.contains(currentUnit)
        }
    }
    
    func raiseAnswerCount() {
        self.answerCount += 1
    }
    
    func isTimeToLevelUp() -> Bool {
        return memberCount < Perspective.maxUnitCount && answerCount >= memberCount * 10
    }
    
    func newMember() -> StackMemberUnit {
        let newUnit = unused.removeLast()
        memberCount += 1
        
        if memberCount % 2 == 0 {
            leftStack.append(newUnit)
            return StackMemberUnit(content: newUnit, order: leftStack.count-1, direction: .left)
        } else {
            rightStack.append(newUnit)
            return StackMemberUnit(content: newUnit, order: rightStack.count-1, direction: .right)
        }
    }
}
