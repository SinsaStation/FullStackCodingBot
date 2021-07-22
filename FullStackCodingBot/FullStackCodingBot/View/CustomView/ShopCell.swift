import UIKit

final class ShopCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    func configure(item: ShopItem) {
        itemImageView.image = UIImage(named: item.image)
    }
}
