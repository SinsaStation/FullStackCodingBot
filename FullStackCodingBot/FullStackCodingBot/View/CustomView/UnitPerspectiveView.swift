import UIKit

final class UnitPerspectiveView: UIView {
    
    private var unitLayers = [CALayer]()
    
    enum Multiplier {
        static let height: CGFloat = 1.0
        static let minSize: CGFloat = 0.01
    }
    
    private lazy var maxWidth = frame.width
    private lazy var maxSize = CGSize(width: maxWidth, height: maxWidth * Multiplier.height)
    private lazy var minSize = CGSize(width: maxWidth * Multiplier.minSize,
                                      height: maxWidth * Multiplier.minSize * Multiplier.height)
    private lazy var maxWeight = CGFloat(GameSetting.count)
    
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
            unitLayers.append(layer)
        }
    }
    
    private func drawUnitLayers() {
        unitLayers.enumerated().forEach { (index, unitLayer) in
            let weight = CGFloat(index)
            unitLayer.frame = layerFrame(weight: weight)
            unitLayer.zPosition = -weight
            self.layer.addSublayer(unitLayer)
        }
    }
    
    private func layerFrame(weight: CGFloat) -> CGRect {
        let layerWidth = maxSize.width - ((maxSize.width - minSize.width) / maxWeight) * weight
        let layerHeight = maxSize.height - ((maxSize.height - minSize.height) / maxWeight) * weight
        let layerSize = CGSize(width: layerWidth, height: layerHeight)
        
        let layerXPoint = (frame.width - layerWidth) * 0.5
        let unitOrder = maxWeight - weight
        let layerYPoint = ((frame.height / maxWeight) * unitOrder - layerHeight) * sqrt(unitOrder * 0.1)
        let layerOrigin = CGPoint(x: layerXPoint, y: layerYPoint)
        
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
        layer.opacity = 0
        
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
