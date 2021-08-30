import UIKit

final class RewardPopupView: UIView {
    
    @IBOutlet weak var backgroundView: UIView!

    func hide() {
        isHidden = true
    }
    
    func show() {
        isHidden = false
        backgroundView.layer.removeAllAnimations()
        let backgroundAnimation = BackgroundAnimation.dissolve(duration: 10,
                                                               colors: BackgroundAnimation.Colors.fever,
                                                               repeatCount: .infinity)
        backgroundView.layer.add(backgroundAnimation, forKey: BackgroundAnimation.key)
    }
}
