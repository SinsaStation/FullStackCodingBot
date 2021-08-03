import UIKit

final class SkyView: UIView {
    
    private var cloudLayers = [CALayer]()
    private let cloudImageName = "item_cloud"
    private let positionKey = #keyPath(CALayer.position)
    private let movingCloudCount = 6
    private let imageCount = 3
    
    enum Direction {
        case toRight
        case toLeft
    }
    
    func startCloudAnimation() {
        clearAll()
        (1...movingCloudCount).forEach { makeCloudMove(weight: $0) }
    }
    
    private func clearAll() {
        cloudLayers.forEach { $0.removeFromSuperlayer() }
    }
    
    private func makeCloudMove(weight: Int) {
        let cloudFrame = cloudFrame(weight: weight)
        let cloudLayer = cloudLayer(frame: cloudFrame)
        layer.addSublayer(cloudLayer)
        cloudLayers.append(cloudLayer)

        let animation = positionAnimation(from: cloudFrame.origin,
                                          to: CGPoint(x: bounds.width+cloudFrame.width,
                                                      y: cloudFrame.origin.y),
                                          duration: Double.random(in: 5...15),
                                          direction: weight % 2 == 0 ? .toLeft : .toRight)
        
        cloudLayer.add(animation, forKey: positionKey)
    }
    
    private func cloudFrame(weight: Int) -> CGRect {
        let cloudHeight = bounds.height/5 * CGFloat.random(in: 0.8...1.3)
        let cloudWidth = cloudHeight * 2.5
        let cloudSize = CGSize(width: cloudWidth, height: cloudHeight)
        
        let weight = CGFloat(weight)
        let xPoint = -cloudWidth
        let yPoint = bounds.height/8 * weight
        let cloudOrigin = CGPoint(x: xPoint, y: yPoint)
        
        return CGRect(origin: cloudOrigin, size: cloudSize)
    }
    
    private func cloudLayer(frame: CGRect) -> CALayer {
        let cloudLayer = CALayer()
        cloudLayer.frame = frame
        cloudLayer.contents = randomCloudImage()?.cgImage
        cloudLayer.contentsGravity = .resizeAspect
        return cloudLayer
    }
    
    private func randomCloudImage() -> UIImage? {
        let randomNumberInString = String(Int.random(in: 1...imageCount))
        let imageName = "\(cloudImageName)\(randomNumberInString)"
        let cloudImage = UIImage(named: imageName)
        return cloudImage
    }
    
    private func positionAnimation(from fromPosition: CGPoint, to toPosition: CGPoint, duration: Double, direction: SkyView.Direction) -> CABasicAnimation {
        let positionAnimation = CABasicAnimation(keyPath: positionKey)
        positionAnimation.fromValue = direction == .toRight ? fromPosition : toPosition
        positionAnimation.toValue = direction == .toRight ? toPosition : fromPosition
        positionAnimation.duration = duration
        positionAnimation.repeatCount = .infinity
        positionAnimation.isRemovedOnCompletion = false
        return positionAnimation
    }
}
