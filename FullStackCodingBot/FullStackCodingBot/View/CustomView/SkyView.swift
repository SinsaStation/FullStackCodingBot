import UIKit

final class SkyView: UIView {
    
    private let cloudImageName = "item_cloud"
    private let positionKey = #keyPath(CALayer.position)
    private let cloudCount = 7
    private let imageCount = 3
    
    enum Direction {
        case toRight
        case toLeft
    }
    
    func startCloudAnimation() {
        for count in 1...cloudCount {
            makeCloudAnimation(for: count)
        }
    }
    
    private func makeCloudAnimation(for count: Int) {
        let cloudHeight = bounds.height/7 * CGFloat.random(in: 0.8...1.3)
        let cloudWidth = cloudHeight * 2.5
        let cloudSize = CGSize(width: cloudWidth, height: cloudHeight)
        
        let weight = CGFloat(count)
        let yPoint = bounds.height/8 * weight - cloudHeight/2
        let cloudOrigin = CGPoint(x: -cloudWidth, y: yPoint)
        let cloudFrame = CGRect(origin: cloudOrigin, size: cloudSize)
    
        let cloudLayer = cloudLayer(frame: cloudFrame)
        layer.addSublayer(cloudLayer)

        let animation = positionAnimation(from: cloudOrigin,
                                          to: CGPoint(x: bounds.width+cloudWidth, y: yPoint),
                                          duration: Double.random(in: 5...15),
                                          direction: count % 2 == 0 ? .toLeft : .toRight)
        
        cloudLayer.add(animation, forKey: positionKey)
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
        return positionAnimation
    }
}
