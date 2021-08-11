import UIKit

final class TimeBarView: UIView {
    
    private let normalColor = UIColor(named: "digitalgreen") ?? UIColor.green
    private let wrongColor = UIColor(named: "red") ?? UIColor.red
    private var fullWidth: CGFloat?
    private var timeSolidLayer: CALayer?
    private var animationAllowed: Bool = true
    
    func changeAnimationStatus(_ isAllowed: Bool) {
        animationAllowed = isAllowed
    }
    
    func setup() {
        if let timeSolidLayer = timeSolidLayer {
            timeSolidLayer.removeAllAnimations()
            timeSolidLayer.removeFromSuperlayer()
        }
        timeSolidLayer = solidLayer()
        fullWidth = timeSolidLayer?.bounds.width
        layer.insertSublayer(timeSolidLayer ?? solidLayer(), at: 0)
    }
    
    private func solidLayer() -> CALayer {
        let solidLayer = CALayer()
        solidLayer.bounds.size = layer.bounds.size
        solidLayer.anchorPoint = CGPoint(x: 0, y: 0)
        solidLayer.position = .zero
        solidLayer.backgroundColor = normalColor.cgColor
        return solidLayer
    }

    func fillAnimation(duration: Double = TimeSetting.readyTime) {
        guard animationAllowed else { return }
        setup()
        
        let toValue: CGFloat = fullWidth ?? ScreenSize.width
        let fromValue: CGFloat = 0
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
    
    func adjust(to percentage: Double) {
        let toValue = width(for: percentage)
        timeSolidLayer?.bounds.size.width = toValue
    }
    
    private func width(for percentage: Double) -> CGFloat {
        let fullWidth = fullWidth ?? ScreenSize.width
        return fullWidth * CGFloat(percentage)
    }
    
    func playWrongMode() {
        timeSolidLayer?.backgroundColor = wrongColor.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            self.timeSolidLayer?.backgroundColor = self.normalColor.cgColor
        }
    }
}
