import UIKit

final class GameBackgroundView: ReplicateAnimationView {

    private lazy var feverColors: [UIColor] = {
        return UnitInfo.allCases.map { UIImage(named: $0.detail.image)?.averageColor ?? UIColor() }
    }()
    
    private let wrongColor = UIColor(named: "red") ?? UIColor.red
    
    private lazy var colorLayer: CALayer = {
        let layer = CALayer()
        layer.frame = self.frame
        return layer
    }()
    
    func playWrongMode() {
        backgroundAnimation(duration: 0.3, colors: [wrongColor, UIColor.darkGray], repeatCount: 0)
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
        colorLayer.add(backgroundColorAnimation, forKey: backgroundColorKey)
        layer.addSublayer(self.colorLayer)
    }
    
    func startFever() {
        backgroundAnimation(duration: 5, colors: feverColors, repeatCount: .infinity)
        draw(withImage: .fever, countPerLine: 2.5)
    }

    func stopFever() {
        layer.sublayers?.forEach({ sublayer in
            sublayer.removeFromSuperlayer()
        })
    }
}
