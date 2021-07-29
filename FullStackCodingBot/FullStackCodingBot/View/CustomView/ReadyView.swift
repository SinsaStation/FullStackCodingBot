import UIKit

final class ReadyView: UIView {
    
    private let allImageNames = UnitInfo.allCases.map { $0.detail.image }
    private var unitLayers = [CALayer]()
    
    enum AnimationKeys {
        static let rotate = "transform.rotation"
        static let position = #keyPath(CALayer.position)
    }
    
    func playAnimation(totalDuration: Double = GameSetting.readyTime+0.3) {
        reset()
        addLayersToPositions()
        let rotateDuration = totalDuration * 0.9
        let throwDuration = totalDuration - rotateDuration
        rotateLayers(for: totalDuration)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+rotateDuration) { [unowned self] in
            self.throwLayers(for: throwDuration)
        }
    }
    
    private func reset() {
        if unitLayers.isEmpty {
            unitLayers = newLayers()
        } else {
            unitLayers.forEach { layer in
                layer.removeAllAnimations()
                layer.removeFromSuperlayer()
                unitLayers.shuffle()
            }
        }
    }
    
    private func newLayers() -> [CALayer] {
        var layers = [CALayer]()
        let allImages = allImageNames.shuffled().map { UIImage(named: $0)?.cgImage }
        let layerWidth = layer.bounds.width / 4
        let layerSize = CGSize(width: layerWidth, height: layerWidth)
        
        allImages.forEach { image in
            let layer = CALayer()
            layer.contents = image
            layer.contentsGravity = .resizeAspect
            layer.bounds.size = layerSize
            layers.append(layer)
        }
        return layers
    }
    
    private func addLayersToPositions() {
        unitLayers.enumerated().forEach { [unowned self] index, layer in
            let position = startPosition(for: index)
            layer.position = position
            self.layer.addSublayer(layer)
        }
    }
    
    private func rotateLayers(for duration: Double) {
        unitLayers.forEach { layer in
            let rotateAnimation = rotateAnimation(for: duration)
            layer.add(rotateAnimation, forKey: AnimationKeys.rotate)
        }
    }
    
    private func rotateAnimation(for totalDuration: Double) -> CABasicAnimation {
        let rotateAnimation = CABasicAnimation(keyPath: AnimationKeys.rotate)
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = 30
        rotateAnimation.duration = totalDuration*1.5
        rotateAnimation.isRemovedOnCompletion = false
        return rotateAnimation
    }
    
    private func throwLayers(for duration: Double) {
        unitLayers.enumerated().forEach { index, layer in
            layer.position = endPosition(for: index)
            let throwAnimation = throwAnimation(for: duration, for: index)
            layer.add(throwAnimation, forKey: AnimationKeys.position)
        }
    }
    
    private func throwAnimation(for duration: Double, for index: Int) -> CAKeyframeAnimation {
        let throwAnimataion = CAKeyframeAnimation(keyPath: AnimationKeys.position)
        throwAnimataion.values = [startPosition(for: index), endPosition(for: index)]
        throwAnimataion.timingFunction = CAMediaTimingFunction.init(name: .easeOut)
        throwAnimataion.duration = duration
        return throwAnimataion
    }
    
    private func startPosition(for index: Int) -> CGPoint {
        let positionX = startX(for: index)
        let positionY = startY(for: index)
        return CGPoint(x: positionX, y: positionY)
    }
    
    private func startX(for index: Int) -> CGFloat {
        let centerX = layer.bounds.width / 2
        
        switch index {
        case 0, 9:
            return centerX
        case 2, 8:
            return centerX * 1.375
        case 4, 6:
            return centerX * 1.75
        case 1, 7:
            return centerX * 0.625
        default:
            return centerX * 0.25
        }
    }
    
    private func startY(for index: Int) -> CGFloat {
        let weight = layer.bounds.height / 7
        
        switch index {
        case 0:
            return weight
        case 1, 2:
            return weight * 2
        case 3, 4:
            return weight * 3
        case 5, 6:
            return weight * 4
        case 7, 8:
            return weight * 5
        default:
            return weight * 6
        }
    }
    
    private func endPosition(for index: Int) -> CGPoint {
        let positionX = endX(for: index)
        let positionY = endY(for: index)
        return CGPoint(x: positionX, y: positionY)
    }
    
    private func endX(for index: Int) -> CGFloat {
        let maxX = layer.bounds.width
        let weight = maxX / 9
        
        switch index {
        case 0, 9:
            return startX(for: index)
        case 1, 7:
            return -weight*2
        case 3, 5:
            return -weight*3
        case 2, 8:
            return maxX+weight*2
        default:
            return maxX+weight*3
        }
    }
    
    private func endY(for index: Int) -> CGFloat {
        let maxY = layer.bounds.height
        let weight = maxY / 4
        
        switch index {
        case 0:
            return -weight*3
        case 1, 2:
            return startY(for: index)-weight
        case 3...6:
            return startY(for: index)
        case 7, 8:
            return startY(for: index)+weight
        default:
            return maxY+weight*3
        }
    }
}
