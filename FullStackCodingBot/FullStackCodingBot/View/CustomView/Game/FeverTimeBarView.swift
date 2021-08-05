import UIKit

final class FeverTimeBarView: UIView {
    
    private let colors = [UIColor.orange.cgColor, UIColor.red.cgColor]
    private var fullWidth: CGFloat?
    private var timeLayer: CAGradientLayer?
    
    func setup() {
        if let timeLayer = timeLayer {
            timeLayer.removeAllAnimations()
            timeLayer.removeFromSuperlayer()
        }
        timeLayer = gradientLayer()
        fullWidth = timeLayer?.bounds.width
        layer.insertSublayer(timeLayer!, at: 0)
        setNeedsDisplay()
    }
    
    private func gradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.bounds.size = layer.bounds.size
        gradientLayer.anchorPoint = CGPoint(x: 0, y: 0)
        gradientLayer.position = .zero
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        return gradientLayer
    }
    
    func adjust(to percentage: Float, duration: Double) {
        guard let timeLayer = timeLayer else { return }
        let fromValue = timeLayer.bounds.width
        let toValue = width(for: percentage)
        timeLayer.bounds.size.width = toValue
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)

        let widthKey = "bounds.size.width"
        let widthAnimation = CABasicAnimation(keyPath: widthKey)
        widthAnimation.fromValue = fromValue
        widthAnimation.toValue = toValue
        widthAnimation.isRemovedOnCompletion = false

        timeLayer.add(widthAnimation, forKey: widthKey)

        CATransaction.commit()
    }
    
    private func width(for percentage: Float) -> CGFloat {
        let fullWidth = fullWidth ?? 1
        return fullWidth * CGFloat(percentage)
    }
}
