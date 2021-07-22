import Foundation

enum ShopItem {
    case adMob
    case gift
    
    var image: String {
        switch self {
        case .adMob:
            return "item_gift_red_ad"
        case .gift:
            return "item_gift_red"
        }
    }
}