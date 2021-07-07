import UIKit

final class UnitPerspectiveView: UIView {
    
    private var unitLayers = [CALayer]()
    private var unitCount: Int?
    
    enum Multiplier {
        static let height: CGFloat = 0.75
        static let minSize: CGFloat = 0.125
    }
    
    private lazy var maxWidth = frame.width * 0.8
    private lazy var maxSize = CGSize(width: maxWidth, height: maxWidth * Multiplier.height)
    private lazy var minSize = CGSize(width: maxWidth * Multiplier.minSize,
                                      height: maxWidth * Multiplier.minSize * Multiplier.height)
    
    func configure(with startingUnits: [Unit]) {
        self.unitCount = startingUnits.count
        
        startingUnits.forEach { unit in
            let imageName = unit.image.name
            self.unitLayers.append(newLayer(with: imageName))
        }
    }
    
    private func newLayer(with imageName: String) -> CALayer {
        let layer = CALayer()
        let logoImage = UIImage(named: imageName)?.cgImage
        layer.contents = logoImage
        layer.contentsGravity = .resizeAspect
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.gray.cgColor
        return layer
    }
    
    func fillUnits() {
        guard let unitCount = unitCount else { return }
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
    
    func removeFirstUnit(to direction: Direction) {
        let layerToAnimate = unitLayers.removeFirst()
        
        animate(layer: layerToAnimate, to: direction)
        
        unitLayers.forEach { layer in
            layer.removeFromSuperlayer()
        }
    }
    
    private func animate(layer: CALayer, to direction: Direction) {
        let currentLocation = layer.position
        
        CATransaction.setCompletionBlock {
            layer.removeFromSuperlayer()
        }
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(1)

        let positionKey = #keyPath(CALayer.position)
        let positionAnimation = CASpringAnimation(keyPath: positionKey)
        positionAnimation.fromValue = currentLocation
        positionAnimation.toValue = locationToSendUnit(for: layer, baseOn: direction)
        positionAnimation.duration = 1
        layer.add(positionAnimation, forKey: positionKey)
        
        CATransaction.commit()
    }
    
    private func locationToSendUnit(for layer: CALayer, baseOn direction: Direction) -> CGPoint {
        let extraMovementX = layer.bounds.width
        let positionY = -layer.bounds.height * 2
        
        switch direction {
        case .left:
            return CGPoint(x: 0 - extraMovementX, y: positionY)
        case .right:
            return CGPoint(x: self.bounds.width + extraMovementX, y: positionY)
        }
    }
    
    func refillLastUnit(with newUnit: Unit) {
        let imageName = newUnit.image.name
        unitLayers.append(newLayer(with: imageName))
    }
}
