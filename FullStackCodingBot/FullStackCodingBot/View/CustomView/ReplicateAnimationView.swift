import UIKit

final class ReplicateAnimationView: UIView {
    
    enum Image {
        case paused
        case gameover
        
        var name: String {
            switch self {
            case .paused:
                return "text_paused"
            case .gameover:
                return "text_gameover"
            }
        }
    }
    
    private func imageLayer(imageName: String, direction: Bool) -> CALayer {
        let imageLayer = CALayer()
        let image = UIImage(named: imageName)
        imageLayer.contents = image?.cgImage
         
        let imageSize = image?.size ?? CGSize()
        imageLayer.frame.size = imageSize
        
        let positionKey = #keyPath(CALayer.position)
        let animation = CABasicAnimation(keyPath: positionKey)
        animation.duration = 3.5
        
        let position = imageLayer.position
        let toPosition = CGPoint(x: position.x - imageSize.width, y: position.y)
        animation.fromValue = direction ? position : toPosition
        
        animation.toValue = direction ? toPosition : position
        animation.repeatCount = .infinity
        imageLayer.add(animation, forKey: positionKey)
        
        return imageLayer
    }

    func draw(withImage imageType: Image) {
        let imageLayer = imageLayer(imageName: imageType.name, direction: true)
        let imageSize = imageLayer.bounds.size
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame.size = CGSize(width: frame.width + imageSize.width,
                                            height: frame.height)
        replicatorLayer.masksToBounds = true
        replicatorLayer.addSublayer(imageLayer)
        layer.addSublayer(replicatorLayer)
        
        let instanceCount = frame.width / imageSize.width + 2
        replicatorLayer.instanceCount = Int(ceil(instanceCount))
        
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(
            imageSize.width, 0, 0
        )

        let verticalReplicatorLayer = CAReplicatorLayer()
        verticalReplicatorLayer.frame.size = frame.size
        verticalReplicatorLayer.masksToBounds = true
        layer.addSublayer(verticalReplicatorLayer)

        let verticalInstanceCount = frame.height / imageSize.height
        verticalReplicatorLayer.instanceCount = Int(ceil(verticalInstanceCount))

        verticalReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(
            0, imageSize.height*2, 0
        )

        verticalReplicatorLayer.addSublayer(replicatorLayer)
        
        // 짝수 줄
        let imageLayer2 = self.imageLayer(imageName: imageType.name, direction: false)

        let replicatorLayer2 = CAReplicatorLayer()
        replicatorLayer2.frame.size = CGSize(width: frame.width + imageSize.width,
                                            height: frame.height)
        replicatorLayer2.frame.origin = CGPoint(x: -imageSize.width/2, y: imageSize.height)
        replicatorLayer2.masksToBounds = true
        replicatorLayer2.addSublayer(imageLayer2)
        layer.addSublayer(replicatorLayer2)
        
        let instanceCount2 = frame.width / imageSize.width + 2
        replicatorLayer2.instanceCount = Int(ceil(instanceCount2))
        
        replicatorLayer2.instanceTransform = CATransform3DMakeTranslation(
            imageSize.width, 0, 0
        )
        
        let verticalReplicatorLayer2 = CAReplicatorLayer()
        verticalReplicatorLayer2.frame.size = frame.size
        verticalReplicatorLayer2.masksToBounds = true
        layer.addSublayer(verticalReplicatorLayer2)

        verticalReplicatorLayer2.instanceCount = Int(ceil(verticalInstanceCount))

        verticalReplicatorLayer2.instanceTransform = CATransform3DMakeTranslation(
            0, imageSize.height*2, 0
        )

        verticalReplicatorLayer2.addSublayer(replicatorLayer2)

    }
}
