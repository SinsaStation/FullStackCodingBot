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
    
    func adjust(to percentage: Double) {
        let toValue = width(for: percentage)
        timeLayer?.bounds.size.width = toValue
    }
    
    private func width(for percentage: Double) -> CGFloat {
        let fullWidth = fullWidth ?? 1
        return fullWidth * CGFloat(percentage)
    }
}
