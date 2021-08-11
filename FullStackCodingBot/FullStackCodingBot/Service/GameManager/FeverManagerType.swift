import Foundation

protocol FeverManagerType {
    
    func reset()
    
    func reduceGauge(by amount: Int)
    
    func feverMayStart(afterFilledBy amount: Int) -> Bool
    
    func feverMayOver(after seconds: Double) -> Bool
    
}
