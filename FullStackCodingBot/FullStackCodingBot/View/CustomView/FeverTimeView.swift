import UIKit

final class FeverTimeView: UIView {
    
    private let duration = CFTimeInterval(GameSetting.feverTime)-0.5
    
    private lazy var timeLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.bounds.size = layer.bounds.size
        gradientLayer.anchorPoint = CGPoint(x: 0, y: 0)
        gradientLayer.position = .zero
        gradientLayer.colors = [UIColor.orange.cgColor, UIColor.red.cgColor]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientLayer.opacity = 0
        return gradientLayer
    }()
    
    func setup() {
        CATransaction.setCompletionBlock {
            self.timeLayer.removeFromSuperlayer()
        }
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        
        let scaleKey = "transform.scale.x"
        let scaleAnimation = CABasicAnimation(keyPath: scaleKey)
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 0.0
        timeLayer.add(scaleAnimation, forKey: scaleKey)
        
        let opacityKey = #keyPath(CAGradientLayer.opacity)
        let opacityAnimation = CABasicAnimation(keyPath: opacityKey)
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.9
        timeLayer.add(opacityAnimation, forKey: opacityKey)
        
        layer.insertSublayer(timeLayer, at: 0)
        
        CATransaction.commit()
    }
}
