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

    func draw(withImage imageType: Image) {
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame.size = CGSize(width: frame.width * 5, height: frame.height)
        // replicatorLayer.frame.origin = CGPoint(x: -frame.size.width, y: 0)
        replicatorLayer.masksToBounds = true
        layer.addSublayer(replicatorLayer)
        
        let imageLayer = CALayer()
        let image = UIImage(named: imageType.name)
        imageLayer.contents = image?.cgImage
         
        let imageSize = image?.size ?? CGSize()
        imageLayer.frame.size = imageSize
        replicatorLayer.addSublayer(imageLayer)
        
        let instanceCount = frame.width / imageSize.width * 4
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
            -imageSize.width/2, imageSize.height, 0
        )

        verticalReplicatorLayer.addSublayer(replicatorLayer)
        
        let positionKey = #keyPath(CALayer.position)
        let animation = CABasicAnimation(keyPath: positionKey)
        animation.duration = 2
        animation.fromValue = imageLayer.position
        let position = imageLayer.position
        animation.toValue = CGPoint(x: position.x - imageSize.width, y: position.y)
        animation.repeatCount = .infinity
        imageLayer.add(animation, forKey: positionKey)

    }
}
