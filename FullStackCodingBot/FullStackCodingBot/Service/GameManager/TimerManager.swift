import Foundation
import RxSwift

enum TimerMode {
    case normal
    case fever
}

final class TimerManager {
    
    var newTimerMode = BehaviorSubject<TimerMode>(value: .normal)
    var timeLeft = BehaviorSubject<Int>(value: Int(GameSetting.startingTime))
    private var totalTime: Int
    private var timerMode: TimerMode
    private var feverTimeManager: FeverTimeManager
    
    init(totalTime: Int = Int(GameSetting.startingTime),
         timerMode: TimerMode = .normal,
         fiverTimeManager: FeverTimeManager = FeverTimeManager()) {
        self.totalTime = totalTime
        self.timerMode = timerMode
        self.feverTimeManager = fiverTimeManager
    }

    func newStart() {
        reset()
    }
    
    private func reset() {
        timerMode = .normal
        newTimerMode.onNext(timerMode)
        
        totalTime = Int(GameSetting.startingTime)
        timeLeft.onNext(totalTime)
        
        feverTimeManager.reset()
    }
    
    func timeMinus(by second: Int) {
        switch timerMode {
        case .normal:
            totalTime -= second
            if totalTime < 0 { totalTime = 0 }
            timeLeft.onNext(totalTime)
            feverTimeManager.reduceGauge()
        case .fever:
            if feverTimeManager.feverMayOver() {
                timerMode = .normal
                newTimerMode.onNext(.normal)
            }
        }
    }
    
    func correct() {
        guard timerMode == .normal else { return }
        
        if feverTimeManager.feverMayStart() {
            timerMode = .fever
            newTimerMode.onNext(.fever)
        }
    }
    
    func wrong() -> UserActionStatus {
        guard timerMode == .normal else { return .feverWrong }
        
        timeMinus(by: GameSetting.wrongTime)
        feverTimeManager.reset()
        
        return .wrong
    }
}
