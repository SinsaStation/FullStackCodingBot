import UIKit
import RxSwift
import RxCocoa

final class MainItemView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    func configure(_ info: Unit) {
        self.itemImageView.image = UIImage(named: info.image)
        self.nameLabel.text = info.image
        self.levelLabel.text = "Lv. \(info.level)"
    }
    
    private func loadXib() {
        let name = String(describing: type(of: self))
        Bundle.main.loadNibNamed(name, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func startAnimation() {
        let circleColor = itemImageView.image?.averageColor ?? UIColor.white
        circleAnimation(color: circleColor)
    }
    
    private func circleAnimation(color: UIColor) {
        let width = frame.width
        let height = frame.height
        let center = CGPoint(x: width/2, y: height/2*0.9)
        let finalWidth = width*2
        
        let ring = CALayer()
        ring.position = center
        ring.bounds.size = CGSize(width: finalWidth, height: finalWidth)
        ring.cornerRadius = finalWidth/2
        ring.borderWidth = finalWidth*0.1
        ring.borderColor = color.cgColor
        backgroundView.layer.addSublayer(ring)
        
        CATransaction.setCompletionBlock {
            ring.removeFromSuperlayer()
        }
        
        CATransaction.begin()
        
        let scaleKey = "transform.scale"
        let scaleAnimation = CAKeyframeAnimation(keyPath: scaleKey)
        
        scaleAnimation.values = [0.001, 0.3, 1.0]
        scaleAnimation.keyTimes = [0.0, 0.25, 0.8]
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        scaleAnimation.duration = 0.8
        ring.add(scaleAnimation, forKey: scaleKey)
        
        CATransaction.commit()
    }
}
