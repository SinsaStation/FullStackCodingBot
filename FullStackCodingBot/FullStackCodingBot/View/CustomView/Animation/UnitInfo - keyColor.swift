import UIKit

extension UnitInfo {
    var keyColor: UIColor {
        return UIImage(named: self.detail.image)?.averageColor ?? UIColor.black
    }
}
