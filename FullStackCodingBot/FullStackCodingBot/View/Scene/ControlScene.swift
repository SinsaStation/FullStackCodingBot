import UIKit
import GameKit
import Firebase

enum ControlScene {
    case alert(AlertMessage)
    case gameCenter(UIViewController)
}

extension ControlScene {
    
    func ControlScene(from identifier: String) -> UIViewController {
        switch self {
        
        case .alert(let message):
            let alerMessage = message.content.message
            let alertScene = UIAlertController(title: alerMessage.title, message: alerMessage.content, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: message.content.confirm, style: .cancel)
            alertScene.addAction(confirmAction)
            return alertScene
            
        case .gameCenter(let viewController):
            return viewController
            
        }
    }
}
