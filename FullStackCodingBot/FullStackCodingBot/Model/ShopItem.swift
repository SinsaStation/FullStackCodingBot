import Foundation
import GoogleMobileAds

enum ShopItem {
    case adMob(GADRewardedAd)
    case gift
    case taken
    case loading
    
    var image: String? {
        switch self {
        case .adMob:
            return "item_gift_red_ad"
        case .gift:
            return "item_gift_red"
        case .taken:
            return nil
        case .loading:
            return "item_gift_loading"
        }
    }
    
    static func isAllTaken(_ items: [ShopItem]) -> Bool {
        return items.filter { shopItem in
                switch shopItem {
                case .taken:
                    return false
                default:
                    return true
                }
            }.isEmpty
    }
}
