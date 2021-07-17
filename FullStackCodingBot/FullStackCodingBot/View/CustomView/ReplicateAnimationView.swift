import UIKit

final class ReplicateAnimationView: UIView {
    
    private var imageCountPerLine: CGFloat = 3.0
    
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
    
    enum Row: CaseIterable {
        case even
        case odd
        
        func origin(imageSize: CGSize) -> CGPoint {
            switch self {
            case .even:
                return CGPoint(x: 0, y: 0)
            case .odd:
                return CGPoint(x: imageSize.width/2 * -1, y: imageSize.height)
            }
        }
    }

    func draw(withImage imageType: Image, countPerLine: Double) {
        let imageName = imageType.name
        imageCountPerLine = CGFloat(countPerLine)
        Row.allCases.forEach { replicates(for: $0, imageName: imageName) }
    }
    
    private func replicates(for row: Row, imageName: String) {
        let imageLayer = imageLayer(imageName: imageName, for: row)
        let imageSize = imageLayer.bounds.size
        
        let horizontalReplicatorLayer = CAReplicatorLayer()
        horizontalReplicatorLayer.frame = CGRect(origin: row.origin(imageSize: imageSize), size: bounds.size)
        horizontalReplicatorLayer.addSublayer(imageLayer)
        
        let horizontalCountInFloat = (frame.width/imageSize.width) + 3
        horizontalReplicatorLayer.instanceCount = Int(horizontalCountInFloat)
        horizontalReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(imageSize.width, 0, 0)

        let verticalReplicatorLayer = CAReplicatorLayer()
        verticalReplicatorLayer.frame.size = bounds.size
    
        let verticalCountInFloat = (frame.height/imageSize.height)/2 + 1
        verticalReplicatorLayer.instanceCount = Int(verticalCountInFloat)
        verticalReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(0, imageSize.height * 2, 0)
        verticalReplicatorLayer.addSublayer(horizontalReplicatorLayer)
        
        layer.addSublayer(verticalReplicatorLayer)
    }
    
    private func imageLayer(imageName: String, for row: Row) -> CALayer {
        let imageLayer = CALayer()
        let image = UIImage(named: imageName)
        let imageSize = image?.size ?? CGSize()
        imageLayer.contents = image?.cgImage
        
        let heightRatio = imageSize.height / imageSize.width
        let newImageWidth = bounds.width / imageCountPerLine
        let newImageHeight = newImageWidth * heightRatio
        imageLayer.bounds.size = CGSize(width: newImageWidth, height: newImageHeight)
    
        let positionKey = #keyPath(CALayer.position)
        let animation = CABasicAnimation(keyPath: positionKey)
        animation.duration = 3.5
        animation.repeatCount = .infinity
        
        let originalPosition = imageLayer.position
        let finalPosition = CGPoint(x: originalPosition.x - newImageWidth, y: originalPosition.y)
        animation.fromValue = row == .even ? originalPosition : finalPosition
        animation.toValue = row == .even ? finalPosition : originalPosition
        
        imageLayer.add(animation, forKey: positionKey)
        return imageLayer
    }
}
