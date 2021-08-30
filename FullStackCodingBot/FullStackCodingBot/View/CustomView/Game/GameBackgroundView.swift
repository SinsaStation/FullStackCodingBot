import UIKit

final class GameBackgroundView: ReplicateAnimationView {

    private let wrongColor = UIColor(named: "red") ?? UIColor.red
    
    private lazy var colorLayer: CALayer = {
        let layer = CALayer()
        layer.frame = self.frame
        return layer
    }()
    
    func playWrongMode() {
        let backgroundAnimation = BackgroundAnimation.dissolve(duration: 0.3,
                                                               colors: [wrongColor, UIColor.darkGray],
                                                               repeatCount: 0)
        setNew(animation: backgroundAnimation, key: BackgroundAnimation.key)
    }

    private func setNew(animation: CAAnimation, key: String) {
        colorLayer.removeAllAnimations()
        colorLayer.add(animation, forKey: key)
        layer.addSublayer(colorLayer)
    }
    
    func startFever() {
        let backgroundAnimation = BackgroundAnimation.dissolve(duration: 5,
                                                               colors: BackgroundAnimation.Colors.fever,
                                                               repeatCount: .infinity)
        setNew(animation: backgroundAnimation, key: BackgroundAnimation.key)
        draw(withImage: .fever, countPerLine: 2.5)
    }

    func stopFever() {
        layer.sublayers?.forEach({ sublayer in
            sublayer.removeFromSuperlayer()
        })
    }
}
