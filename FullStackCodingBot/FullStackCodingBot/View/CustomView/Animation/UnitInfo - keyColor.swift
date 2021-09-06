import UIKit

extension UnitInfo {
    func keyColor(blend: UIColor.Blend = .normal) -> UIColor {
        let unitImage = UIImage(named: self.detail.image)
        return UIColor.average(from: unitImage, blend: blend)
    }
}
