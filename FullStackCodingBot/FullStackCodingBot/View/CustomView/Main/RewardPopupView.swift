import UIKit

final class RewardPopupView: UIView {
    
    @IBOutlet weak var backgroundView: UIView!
    
    private lazy var feverColors: [UIColor] = {
        return UnitInfo.allCases.map { UIImage(named: $0.detail.image)?.averageColor ?? UIColor() }
    }()
    
    func hide() {
        isHidden = true
    }
    
    func show() {
        isHidden = false
        backgroundAnimation(duration: 10, colors: feverColors, repeatCount: .infinity)
    }
    
    private func backgroundAnimation(duration: Double, colors: [UIColor], repeatCount: Float) {
        let backgroundColorKey = #keyPath(CALayer.backgroundColor)
        let backgroundColorAnimation = CAKeyframeAnimation(keyPath: backgroundColorKey)
        backgroundColorAnimation.values = colors.map { $0.cgColor }
        backgroundColorAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        backgroundColorAnimation.duration = duration
        backgroundColorAnimation.calculationMode = .linear
        backgroundColorAnimation.repeatCount = repeatCount
        backgroundColorAnimation.isRemovedOnCompletion = false
        backgroundView.layer.removeAllAnimations()
        backgroundView.layer.add(backgroundColorAnimation, forKey: backgroundColorKey)
    }
}
