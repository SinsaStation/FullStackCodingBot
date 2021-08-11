import Foundation
import RxSwift

protocol TimeManagerType {
    
    var newTimerMode: BehaviorSubject<TimeMode> { get }
    
    var timeLeft: BehaviorSubject<Double> { get }
    
    var feverTimeLeft: BehaviorSubject<Double?> { get }
    
    func newStart()
    
    func timeMinus(by second: Double)
    
    func correct()
    
    func wrong() -> UserActionStatus
    
}
