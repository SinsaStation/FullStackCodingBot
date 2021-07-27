import Foundation

final class FeverTimeManager {
    private var timeLeft: Int
    private var gauge: Int
    
    init(timeLeft: Int = 0, gauge: Int = 0) {
        self.timeLeft = timeLeft
        self.gauge = gauge
    }
    
    func reset() {
        gauge = .zero
    }
    
    func reduceGauge() {
        gauge -= 1
        
        if gauge < 0 {
            gauge = 0
        }
    }
    
    func reduceTime() {
        timeLeft -= 1
    }
    
    func feverMayStart() -> Bool {
        gauge += 1
        
        if gauge >= GameSetting.feverGaugeMax {
            timeLeft = GameSetting.feverTime
            return true
        } else {
            return false
        }
    }
    
    func feverMayOver() -> Bool {
        if timeLeft <= 0 {
            reset()
            return true
        } else {
            return false
        }
    }
}
