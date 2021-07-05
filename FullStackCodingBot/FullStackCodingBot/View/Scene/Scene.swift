import UIKit

enum Scene {
    case main(MainViewModel)
    case gift(GiftViewModel)
    case ad(AdvertiseViewModel)
    case rank(RankViewModel)
    case item(ItemViewModel)
}

extension Scene {
    
    func instantiate(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        switch self {
        case .main(let viewModel):
            guard var mainVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.main) as? MainViewController else {
                fatalError()
            }
            mainVC.bind(viewModel: viewModel)
            return mainVC
            
        case .gift(let viewModel):
            guard var giftVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.gift) as? GiftViewController else {
                fatalError()
            }
            giftVC.bind(viewModel: viewModel)
            return giftVC
        
        case .ad(let viewModel):
            guard var advertiseVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.ad) as? AdvertiseViewController else {
                fatalError()
            }
            advertiseVC.bind(viewModel: viewModel)
            return advertiseVC
            
        case .rank(let viewModel):
            guard var rankVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.rank) as? RankViewController else {
                fatalError()
            }
            rankVC.bind(viewModel: viewModel)
            return rankVC
            
        case .item(let viewModel):
            guard var itemVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.item) as? ItemViewController else {
                fatalError()
            }
            itemVC.bind(viewModel: viewModel)
            return itemVC
        }
    }
}
