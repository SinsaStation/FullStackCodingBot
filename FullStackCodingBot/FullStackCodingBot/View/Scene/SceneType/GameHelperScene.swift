import UIKit
import GameKit
import Firebase

enum GameHelperScene {
    case setting(MainViewModel)
    case howToPlay(HowToPlayViewModel)
    case story(StoryViewModel)
}

extension GameHelperScene: SceneType {
    
    func instantiate(from identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: identifier, bundle: nil)
        switch self {
        
        case .setting(let viewModel):
            guard var settingVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.setting) as? SettingViewController else {
                Firebase.Analytics.logEvent("ViewControllerError", parameters: nil)
                fatalError()
            }
            settingVC.bind(viewModel: viewModel)
            return settingVC
            
        case .howToPlay(let viewModel):
            guard var howToVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.howTo) as? HowToPlayViewController else {
                Firebase.Analytics.logEvent("ViewControllerError", parameters: nil)
                fatalError()
            }
            howToVC.bind(viewModel: viewModel)
            return howToVC
            
        case .story(let viewModel):
            guard var storyVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.story) as? StoryViewController else {
                Firebase.Analytics.logEvent("ViewControllerError", parameters: nil)
                fatalError()
            }
            storyVC.bind(viewModel: viewModel)
            return storyVC
            
        }
    }
}
