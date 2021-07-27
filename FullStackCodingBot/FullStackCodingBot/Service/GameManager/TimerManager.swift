import Foundation
import RxSwift

enum TimerMode {
    case normal
    case fever
}

final class TimerManager {
    
    private var totalTime = 0
    private var timerMode = TimerMode.normal
    private var feverTime = 0
    private var feverGauge = 0
    
    var newTimerStatus = BehaviorSubject<TimerMode>(value: .normal)
    var timeLeft = BehaviorSubject<Int>(value: Int(GameSetting.startingTime))
        
    func newStart() {
        reset()
    }
    
    private func reset() {
        timerMode = .normal
        newTimerStatus.onNext(timerMode)
        
        totalTime = Int(GameSetting.startingTime)
        timeLeft.onNext(totalTime)
        
        resetFever()
    }
    
    private func resetFever() {
        feverGauge = .zero
    }
    
    func timeMinus(by second: Int) {
        switch timerMode {
        case .normal:
            totalTime -= second
            if totalTime < 0 { totalTime = 0 }
            timeLeft.onNext(totalTime)
            
            reduceFever()
        case .fever:
            feverTime -= 1
            if feverMayOver() { newTimerStatus.onNext(.normal) }
        }
    }
    
    private func reduceFever() {
        feverGauge -= 1
        
        if feverGauge < 0 {
            feverGauge = 0
        }
    }
    
    func correct() {
        if feverMayStart() {
            newTimerStatus.onNext(.fever)
        }
    }
    
    private func feverMayStart() -> Bool {
        guard timerMode == .normal else { return false }

        feverGauge += 1
        
        if feverGauge >= GameSetting.feverGaugeMax {
            timerMode = .fever
            feverTime = GameSetting.feverTime
            return true
        }
        return false
    }
    
    private func feverMayOver() -> Bool {
        if feverTime <= 0 {
            timerMode = .normal
            feverGauge = 0
            return true
        }
        return false
    }
    
    func wrong() -> UserActionStatus {
        guard timerMode == .normal else { return .feverWrong }
        
        timeMinus(by: GameSetting.wrongTime)
        feverGauge = 0
        
        return .wrong
    }
}
