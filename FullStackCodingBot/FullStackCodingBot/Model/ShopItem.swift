import Foundation
import GoogleMobileAds

enum ShopItem {
    case adMob(GADRewardedAd)
    case gift
    case taken
    
    var image: String? {
        switch self {
        case .adMob:
            return "item_gift_red_ad"
        case .gift:
            return "item_gift_red"
        case .taken:
            return nil
        }
    }
}
