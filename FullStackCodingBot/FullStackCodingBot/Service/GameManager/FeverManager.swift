import Foundation

final class FeverManager: FeverManagerType {
    
    private var timeLeft: Int
    private var gauge: Int
    
    init(timeLeft: Int = 0, gauge: Int = 0) {
        self.timeLeft = timeLeft
        self.gauge = gauge
    }
    
    func reset() {
        gauge = .zero
    }
    
    func reduceGauge(by amount: Int) {
        updateGuage(by: -amount)

        if gauge < 0 {
            reset()
        }
    }
    
    private func updateGuage(by amount: Int) {
        gauge += amount
    }

    func feverMayStart(afterFilledBy amount: Int) -> Bool {
        updateGuage(by: amount)
        
        if gauge >= GameSetting.feverGaugeMax {
            timeLeft = GameSetting.feverTime
            return true
        } else {
            return false
        }
    }
    
    func feverMayOver(after seconds: Int) -> Bool {
        reduceTime(by: seconds)
        
        if timeLeft <= 0 {
            reset()
            return true
        } else {
            return false
        }
    }
    
    private func reduceTime(by seconds: Int) {
        timeLeft -= seconds
    }
}
