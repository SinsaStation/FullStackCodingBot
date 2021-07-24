import UIKit

final class GameBackgroundView: ReplicateAnimationView {

    private lazy var colors: [UIColor] = {
        return UnitInfo.allCases.map { UIImage(named: $0.detail.image)?.averageColor ?? UIColor() }
    }()
    
    private lazy var feverLayer: CALayer = {
        let layer = CALayer()
        layer.frame = self.frame
        return layer
    }()
    
    func startFever() {
        backgroundAnimation()
        draw(withImage: .fever, countPerLine: 2.5)
    }
    
    private func backgroundAnimation() {
        let backgroundColorKey = #keyPath(CALayer.backgroundColor)
        let backgroundColorAnimation = CAKeyframeAnimation(keyPath: backgroundColorKey)
        backgroundColorAnimation.values = colors.map { $0.cgColor }
        backgroundColorAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        backgroundColorAnimation.duration = 5
        backgroundColorAnimation.calculationMode = .linear
        backgroundColorAnimation.repeatCount = .infinity
        backgroundColorAnimation.isRemovedOnCompletion = false
        layer.addSublayer(feverLayer)
        feverLayer.add(backgroundColorAnimation, forKey: backgroundColorKey)
    }
    
    func stopFever() {
        layer.sublayers?.forEach({ sublayer in
            sublayer.removeFromSuperlayer()
        })
    }
}
