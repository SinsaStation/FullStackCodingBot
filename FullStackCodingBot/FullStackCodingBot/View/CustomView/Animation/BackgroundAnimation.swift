import UIKit

struct BackgroundAnimation {
    
    static let key = #keyPath(CALayer.backgroundColor)
    
    enum Colors {
        static let fever = UnitInfo.allCases.map { $0.keyColor }
    }
    
    static func dissolve(duration: Double, colors: [UIColor], repeatCount: Float) -> CAKeyframeAnimation {
        let backgroundColorKey = BackgroundAnimation.key
        let dissolveAnimation = CAKeyframeAnimation(keyPath: backgroundColorKey)
        dissolveAnimation.values = colors.map { $0.cgColor }
        dissolveAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        dissolveAnimation.duration = duration
        dissolveAnimation.calculationMode = .linear
        dissolveAnimation.repeatCount = repeatCount
        dissolveAnimation.isRemovedOnCompletion = false
        return dissolveAnimation
    }
}
