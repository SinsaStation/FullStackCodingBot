import Foundation

protocol GameUnitManagerType {
    
    func resetAll()
    
    func startings() -> [Unit]
    
    func removeAndRefilled() -> [Unit]
    
    func isMoveActionCorrect(to direction: Direction) -> Bool
    
    func currentHeadUnitScore() -> Int?
    
    func isTimeToLevelUp(afterRaiseCountBy amount: Int) -> Bool
    
    func newMember() -> StackMemberUnit
    
    func updateUnits(_ units: [Unit])
    
}
