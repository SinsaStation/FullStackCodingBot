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
        default:
            break
        }
    }
    
}
