import UIKit

final class ShopCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    func configure(item: ShopItem) {
        let imageName = item.image
        let image = imageName == nil ? UIImage() : UIImage(named: imageName!)
        itemImageView.image = image
    }
}
