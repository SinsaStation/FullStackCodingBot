import Foundation
import RxSwift

enum TimeMode {
    case normal
    case fever
}

struct TimeManager: TimeManagerType {
    
    private let startMode: TimeMode
    private let totalTime: Double
    private var feverTimeManager: FeverManagerType
    private(set) var newTimerMode: BehaviorSubject<TimeMode>
    private(set) var timeLeft: BehaviorSubject<Double>
    private(set) var feverTimeLeft: BehaviorSubject<Double?>
    
    init(timerMode: TimeMode = .normal,
         totalTime: Double = Double(GameSetting.startingTime),
         feverManager: FeverManagerType = FeverManager()) {
        self.startMode = timerMode
        self.totalTime = totalTime
        self.newTimerMode = BehaviorSubject<TimeMode>(value: timerMode)
        self.timeLeft = BehaviorSubject<Double>(value: totalTime)
        self.feverTimeLeft = BehaviorSubject<Double?>(value: nil)
        self.feverTimeManager = feverManager
    }

    func newStart() {
        reset()
    }
    
    private func reset() {
        newTimerMode.onNext(startMode)
        timeLeft.onNext(totalTime)
        feverTimeManager.reset()
    }
    
    func timeMinus(by second: Double) {
        guard let currentMode = try? newTimerMode.value() else { return }
        
        switch currentMode {
        case .normal:
            guard let currentTime = try? timeLeft.value() else { return }
            let newTimeLeft = timeReduced(by: second, from: currentTime)
            newTimeLeft == 0 ? timeLeft.onCompleted() : timeLeft.onNext(newTimeLeft)
            let isSolidNumber = newTimeLeft == Double(Int(newTimeLeft))
            if isSolidNumber { feverTimeManager.reduceGauge(by: 1) }
        case .fever:
            guard let currentFeverTime = try? feverTimeLeft.value() else { return }
            let newFeverTimeLeft = timeReduced(by: second, from: currentFeverTime)
            feverTimeLeft.onNext(newFeverTimeLeft)
            if feverTimeManager.feverMayOver(after: second) {
                newTimerMode.onNext(.normal)
            }
        }
    }
    
    private func timeReduced(by second: Double, from currentTime: Double) -> Double {
        let newTime = currentTime - second
        return newTime >= 0 ? newTime : 0
    }
    
    func correct() {
        guard let currentMode = try? newTimerMode.value(),
              currentMode == .normal else { return }

        if feverTimeManager.feverMayStart(afterFilledBy: 1) {
            newTimerMode.onNext(.fever)
            feverTimeLeft.onNext(GameSetting.feverTime)
        }
    }
    
    func wrong() -> UserActionStatus {
        guard let currentMode = try? newTimerMode.value(),
              currentMode == .normal else { return .feverWrong }
        
        timeMinus(by: GameSetting.wrongTime)
        feverTimeManager.reset()
        
        return .wrong
    }
}
