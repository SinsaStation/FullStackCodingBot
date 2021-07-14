import UIKit

final class UnitPerspectiveView: UIView {
    
    private var unitLayers = [CALayer]()
    private var unitCount = Perspective.count
    
    enum Multiplier {
        static let height: CGFloat = 0.75
        static let minSize: CGFloat = 0.125
    }
    
    private lazy var maxWidth = frame.width * 0.8
    private lazy var maxSize = CGSize(width: maxWidth, height: maxWidth * Multiplier.height)
    private lazy var minSize = CGSize(width: maxWidth * Multiplier.minSize,
                                      height: maxWidth * Multiplier.minSize * Multiplier.height)
    
    func configure(with unitImages: [String]) {
        unitLayers.isEmpty ? fillLayers(with: unitImages) : fillLayers(with: [unitImages.last!])
        drawUnitLayers()
    }
    
    private func fillLayers(with imageNames: [String]) {
        imageNames.forEach { imageName in
            let layer = CALayer()
            let logoImage = UIImage(named: imageName)?.cgImage
            layer.contents = logoImage
            layer.contentsGravity = .resizeAspect
            layer.shadowOpacity = 0.3
            layer.shadowColor = UIColor.gray.cgColor
            unitLayers.append(layer)
        }
    }
    
    private func drawUnitLayers() {
        let maxWeight = CGFloat(unitCount)
        
        unitLayers.enumerated().forEach { (index, layer) in
            let weight = CGFloat(index)
            layer.frame = layerFrame(weight: weight, maxWeight: maxWeight)
            layer.zPosition = -weight
            
            self.layer.addSublayer(layer)
        }
    }
    
    private func layerFrame(weight: CGFloat, maxWeight: CGFloat) -> CGRect {
        let layerSize = CGSize(width: maxSize.width - ((maxSize.width - minSize.width) / maxWeight) * weight,
                               height: maxSize.height - ((maxSize.height - minSize.height) / maxWeight) * weight)
        let layerOrigin = CGPoint(x: (frame.width - layerSize.width) * 0.5,
                                  y: (frame.height / maxWeight) * (maxWeight - weight) - layerSize.height)
        return CGRect(origin: layerOrigin, size: layerSize)
    }
    
    func removeFirstUnitLayer(to direction: Direction) {
        let layerToAnimate = unitLayers.removeFirst()
        
        animate(layer: layerToAnimate, to: direction)
        
        unitLayers.forEach { layer in
            layer.removeFromSuperlayer()
        }
    }
    
    private func animate(layer: CALayer, to direction: Direction) {
        CATransaction.setCompletionBlock {
            layer.removeFromSuperlayer()
        }
        
        CATransaction.begin()
        
        let rotateKey = "transform.rotation"
        let rotateAnimation = CABasicAnimation(keyPath: rotateKey)
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = 359
        
        let positionKey = #keyPath(CALayer.position)
        let positionAnimation = CASpringAnimation(keyPath: positionKey)
        positionAnimation.damping = 10
        positionAnimation.fromValue = layer.position
        positionAnimation.toValue = locationToSendUnit(for: layer, baseOn: direction)
        
        let opacityKey = #keyPath(CALayer.opacity)
        let opacityAnimation = CABasicAnimation(keyPath: opacityKey)
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        
        let totalAnimationGroup = CAAnimationGroup()
        totalAnimationGroup.animations = [rotateAnimation, positionAnimation, opacityAnimation]
        totalAnimationGroup.duration = 1.5
        totalAnimationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        layer.add(totalAnimationGroup, forKey: "totalAnimation")
        
        CATransaction.commit()
    }
    
    private func locationToSendUnit(for layer: CALayer, baseOn direction: Direction) -> CGPoint {
        let extraMovementX = layer.bounds.width
        let positionY = -layer.bounds.height * 3
        
        switch direction {
        case .left:
            return CGPoint(x: 0 - extraMovementX, y: positionY)
        case .right:
            return CGPoint(x: self.bounds.width + extraMovementX, y: positionY)
        }
    }
    
    func clearAll() {
        unitLayers.forEach { layer in
            layer.removeFromSuperlayer()
        }
        unitLayers.removeAll()
    }
}
