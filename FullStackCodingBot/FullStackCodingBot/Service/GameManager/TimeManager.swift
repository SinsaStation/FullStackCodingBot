import Foundation
import RxSwift

enum TimeMode {
    case normal
    case fever
}

struct TimeManager: TimeManagerType {
    
    private let startMode: TimeMode
    private let totalTime: Int
    private var feverTimeManager: FeverManagerType
    private(set) var newTimerMode: BehaviorSubject<TimeMode>
    private(set) var timeLeft: BehaviorSubject<Int>
    private(set) var feverTimeLeft: BehaviorSubject<Int?>
    
    init(timerMode: TimeMode = .normal,
         totalTime: Int = Int(GameSetting.startingTime),
         feverManager: FeverManagerType = FeverManager()) {
        self.startMode = timerMode
        self.totalTime = totalTime
        self.newTimerMode = BehaviorSubject<TimeMode>(value: timerMode)
        self.timeLeft = BehaviorSubject<Int>(value: totalTime)
        self.feverTimeLeft = BehaviorSubject<Int?>(value: nil)
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
    
    func timeMinus(by second: Int) {
        guard let currentMode = try? newTimerMode.value() else { return }
        
        switch currentMode {
        case .normal:
            guard let currentTime = try? timeLeft.value() else { return }
            let newTimeLeft = timeReduced(by: second, from: currentTime)
            
            if newTimeLeft == 0 {
                timeLeft.onCompleted()
            } else {
                timeLeft.onNext(newTimeLeft)
            }
            feverTimeManager.reduceGauge(by: second)
        case .fever:
            guard let currentFeverTime = try? feverTimeLeft.value() else { return }
            let newFeverTimeLeft = timeReduced(by: second, from: currentFeverTime)
            feverTimeLeft.onNext(newFeverTimeLeft)
            if feverTimeManager.feverMayOver(after: second) {
                newTimerMode.onNext(.normal)
            }
        }
    }
    
    private func timeReduced(by second: Int, from currentTime: Int) -> Int {
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
