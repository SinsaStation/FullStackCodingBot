import Foundation

protocol GameUnitManagerType {
    
    func resetAll()
    
    func startings() -> [Unit]
    
    func removeAndRefilled() -> [Unit]
    
    func isMoveActionCorrect(to direction: Direction) -> Bool
    
    func currentHeadUnitScore() -> Int?
    
    func raiseAnswerCount()
    
    func isTimeToLevelUp() -> Bool
    
    func newMember() -> StackMemberUnit
    
}
