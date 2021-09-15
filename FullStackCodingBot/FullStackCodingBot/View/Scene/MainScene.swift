import UIKit
import GameKit
import Firebase

enum MainScene {
    case main(MainViewModel)
    case setting(MainViewModel)
    case howToPlay(HowToPlayViewModel)
    case story(StoryViewModel)
    case shop(ShopViewModel)
    case rank(RankViewModel)
    case item(ItemViewModel)
}

extension MainScene: SceneType {
    
    func instantiate(from identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: identifier, bundle: nil)
        switch self {
        
        case .main(let viewModel):
            guard var mainVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.main) as? MainViewController else {
                Firebase.Analytics.logEvent("ViewControllerError", parameters: nil)
                fatalError()
            }
            mainVC.bind(viewModel: viewModel)
            return mainVC
            
        case .shop(let viewModel):
            guard var shopVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.shop) as? ShopViewController else {
                Firebase.Analytics.logEvent("ViewControllerError", parameters: nil)
                fatalError()
            }
            shopVC.bind(viewModel: viewModel)
            return shopVC
            
        case .rank(let viewModel):
            guard var rankVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.rank) as? RankViewController else {
                Firebase.Analytics.logEvent("ViewControllerError", parameters: nil)
                fatalError()
            }
            rankVC.gameCenterDelegate = viewModel
            rankVC.leaderboardIdentifier = IdentifierGC.leaderboard
            rankVC.viewState = .leaderboards
            rankVC.bind(viewModel: viewModel)
            return rankVC
            
        case .item(let viewModel):
            guard var itemVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.item) as? ItemViewController else {
                Firebase.Analytics.logEvent("ViewControllerError", parameters: nil)
                fatalError()
            }
            itemVC.bind(viewModel: viewModel)
            return itemVC
            
        case .setting(let viewModel):
            guard var settingVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.setting) as? SettingViewController else {
                Firebase.Analytics.logEvent("ViewControllerError", parameters: nil)
                fatalError()
            }
            settingVC.bind(viewModel: viewModel)
            return settingVC
            
        case .story(let viewModel):
            guard var storyVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.story) as? StoryViewController else {
                Firebase.Analytics.logEvent("ViewControllerError", parameters: nil)
                fatalError()
            }
            storyVC.bind(viewModel: viewModel)
            return storyVC
            
        case .howToPlay(let viewModel):
            guard var howToVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.howTo) as? HowToPlayViewController else {
                Firebase.Analytics.logEvent("ViewControllerError", parameters: nil)
                fatalError()
            }
            howToVC.bind(viewModel: viewModel)
            return howToVC
            
        }
    }
}
