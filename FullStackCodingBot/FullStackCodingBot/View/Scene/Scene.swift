import UIKit

enum Scene {
    case main(MainViewModel)
    case shop(ShopViewModel)
    case rank(RankViewModel)
    case item(ItemViewModel)
    case game(GameViewModel)
    case pause(PauseViewModel)
    case gameOver(GameOverViewModel)
}

extension Scene {
    
    func instantiate(from storyboard: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        switch self {
        case .main(let viewModel):
            guard var mainVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.main) as? MainViewController else {
                fatalError()
            }
            mainVC.bind(viewModel: viewModel)
            return mainVC
            
        case .shop(let viewModel):
            guard var shopVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.shop) as? ShopViewController else {
                fatalError()
            }
            shopVC.bind(viewModel: viewModel)
            return shopVC
            
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
            
        case .game(let viewModel):
            guard var gameVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.game) as? GameViewController else {
                fatalError()
            }
            gameVC.bind(viewModel: viewModel)
            return gameVC
            
        case .pause(let viewModel):
            guard var pauseVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.pause) as? PauseViewController else {
                fatalError()
            }
            pauseVC.bind(viewModel: viewModel)
            return pauseVC
            
        case .gameOver(let viewModel):
            guard var gameOverVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.gameOver) as? GameOverViewController else {
                fatalError()
            }
            gameOverVC.bind(viewModel: viewModel)
            return gameOverVC
        }
    }
}
