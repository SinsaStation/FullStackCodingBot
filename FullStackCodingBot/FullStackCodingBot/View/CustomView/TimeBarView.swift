import UIKit

final class TimeBarView: UIView {
    
    private let normalColor = UIColor(named: "digitalgreen") ?? UIColor.green
    private let wrongColor = UIColor(named: "red") ?? UIColor.red
    private var fullWidth: CGFloat?
    private var timeSolidLayer: CALayer?
    
    private func solidLayer() -> CALayer {
        let solidLayer = CALayer()
        solidLayer.bounds.size = layer.bounds.size
        solidLayer.anchorPoint = CGPoint(x: 0, y: 0)
        solidLayer.position = .zero
        solidLayer.backgroundColor = normalColor.cgColor
        return solidLayer
    }
    
    func setup() {
        if let timeSolidLayer = timeSolidLayer {
            timeSolidLayer.removeAllAnimations()
            timeSolidLayer.removeFromSuperlayer()
        }
        timeSolidLayer = solidLayer()
        fullWidth = timeSolidLayer?.bounds.width
        layer.insertSublayer(timeSolidLayer!, at: 0)
        setNeedsDisplay()
    }
    
    func playWrongMode() {
        timeSolidLayer?.backgroundColor = wrongColor.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.timeSolidLayer?.backgroundColor = self.normalColor.cgColor
        }
    }
    
    func timeAdjust(to percentage: Float, for duration: Double) {
        let fromValue = timeSolidLayer?.bounds.width
        let toValue = width(for: percentage)
        
        timeSolidLayer?.bounds.size.width = toValue
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)

        let widthKey = "bounds.size.width"
        let widthAnimation = CABasicAnimation(keyPath: widthKey)
        widthAnimation.fromValue = fromValue
        widthAnimation.toValue = toValue
        widthAnimation.isRemovedOnCompletion = false
        
        timeSolidLayer?.add(widthAnimation, forKey: widthKey)

        CATransaction.commit()
    }
    
    private func width(for percentage: Float) -> CGFloat {
        let fullWidth = fullWidth ?? 1
        return fullWidth * CGFloat(percentage)
    }
}

final class FeverTimeBarView: UIView {
    private let duration = CFTimeInterval(GameSetting.feverTime)-0.5
    private lazy var timeGradientLayer: CAGradientLayer = {
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
            self.timeGradientLayer.removeFromSuperlayer()
        }
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        
        let scaleKey = "transform.scale.x"
        let scaleAnimation = CABasicAnimation(keyPath: scaleKey)
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 0.0
        timeGradientLayer.add(scaleAnimation, forKey: scaleKey)
        
        let opacityKey = #keyPath(CAGradientLayer.opacity)
        let opacityAnimation = CABasicAnimation(keyPath: opacityKey)
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.9
        timeGradientLayer.add(opacityAnimation, forKey: opacityKey)
        
        layer.insertSublayer(timeGradientLayer, at: 0)
        
        CATransaction.commit()
    }
}
