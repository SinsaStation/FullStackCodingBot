import UIKit

final class TimeBarView: UIView {
    
    private let normalColor = UIColor(named: "digitalgreen") ?? UIColor.green
    private let wrongColor = UIColor(named: "red") ?? UIColor.red
    private var fullWidth: CGFloat?
    private var timeSolidLayer: CALayer?
    
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
    
    private func solidLayer() -> CALayer {
        let solidLayer = CALayer()
        solidLayer.bounds.size = layer.bounds.size
        solidLayer.anchorPoint = CGPoint(x: 0, y: 0)
        solidLayer.position = .zero
        solidLayer.backgroundColor = normalColor.cgColor
        return solidLayer
    }
    
    func adjust(to percentage: Float) {
        let toValue = width(for: percentage)
        timeSolidLayer?.bounds.size.width = toValue
    }
    
    private func width(for percentage: Float) -> CGFloat {
        let fullWidth = fullWidth ?? 1
        return fullWidth * CGFloat(percentage)
    }
    
    func playWrongMode() {
        timeSolidLayer?.backgroundColor = wrongColor.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.timeSolidLayer?.backgroundColor = self.normalColor.cgColor
        }
    }
}
