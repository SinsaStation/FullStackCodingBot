import Foundation
import RxSwift

protocol TimeManagerType {
    
    var newTimerMode: BehaviorSubject<TimeMode> { get }
    
    var timeLeft: BehaviorSubject<Int> { get }
    
    func newStart()
    
    func timeMinus(by second: Int)
    
    func correct()
    
    func wrong() -> UserActionStatus
    
}
