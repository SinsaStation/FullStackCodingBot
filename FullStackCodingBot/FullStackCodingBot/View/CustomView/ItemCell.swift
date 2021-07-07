import UIKit

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    func configure(unit: Unit) {
        itemImageView.image = UIImage(named: unit.image.name)
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return "\(self)"
    }
}
