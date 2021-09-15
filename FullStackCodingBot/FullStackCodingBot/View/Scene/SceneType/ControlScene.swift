import UIKit
import GameKit
import Firebase

enum ControlScene {
    case alert(AlertMessage)
    case gameCenter(UIViewController)
    case setting(MainViewModel)
    case howToPlay(HowToPlayViewModel)
    case story(StoryViewModel)
}

extension ControlScene: SceneType {
    
    func instantiate(from identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: identifier, bundle: nil)
        switch self {
        
        case .alert(let message):
            let alerMessage = message.content.message
            let alertScene = UIAlertController(title: alerMessage.title, message: alerMessage.content, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: message.content.confirm, style: .cancel)
            alertScene.addAction(confirmAction)
            return alertScene
            
        case .gameCenter(let viewController):
            return viewController
            
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
