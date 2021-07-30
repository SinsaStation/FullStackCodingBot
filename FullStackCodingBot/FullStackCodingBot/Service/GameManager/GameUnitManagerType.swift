import Foundation

protocol GameUnitManagerType {
    
    func reset(with units: [Unit])
    
    func startings() -> [Unit]
    
    func removeAndRefilled() -> [Unit]
    
    func isMoveActionCorrect(to direction: Direction) -> Bool
    
    func currentHeadUnitScore() -> Int?
    
    func isTimeToLevelUp(afterRaiseCountBy amount: Int) -> Bool
    
    func newMember() -> StackMemberUnit

}
