import UIKit

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
        itemImageView.image = UIImage(named: info.image)
        nameLabel.text = info.image
        levelLabel.text = "Lv. \(info.level)"
    }
    
    private func loadXib() {
        let name = String(describing: type(of: self))
        Bundle.main.loadNibNamed(name, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func startAnimation(with colors: [UIColor]) {
        circleAnimation(color: colors[0])
    }
    
    private func circleAnimation(color: UIColor) {
        let width = frame.width
        let height = frame.height
        let center = CGPoint(x: width/2, y: height/2*0.9)
        let finalWidth = width * 1.5
        
        let outerCircle = CALayer()
        outerCircle.backgroundColor = color.cgColor
        outerCircle.bounds.size = CGSize(width: finalWidth*1.2, height: finalWidth*1.2)
        outerCircle.cornerRadius = finalWidth*0.6
        outerCircle.position = center
        backgroundView.layer.addSublayer(outerCircle)
        
        let innerCircle = CALayer()
        innerCircle.backgroundColor = UIColor(named: "darkgreen")?.cgColor
        innerCircle.bounds.size = CGSize(width: finalWidth, height: finalWidth)
        innerCircle.cornerRadius = finalWidth*0.5
        innerCircle.position = center
        backgroundView.layer.addSublayer(innerCircle)
        
        CATransaction.setCompletionBlock {
            innerCircle.removeFromSuperlayer()
            outerCircle.removeFromSuperlayer()
        }
        
        CATransaction.begin()
        
        let scaleKey = "transform.scale"
        let scaleAnimation = CAKeyframeAnimation(keyPath: scaleKey)
        
        scaleAnimation.values = [0.01, 0.45, 1.0]
        scaleAnimation.keyTimes = [0.0, 0.25, 0.8]
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        scaleAnimation.duration = 0.8

        innerCircle.add(scaleAnimation, forKey: scaleKey)
        outerCircle.add(scaleAnimation, forKey: scaleKey)
        
        CATransaction.commit()
    }
}
