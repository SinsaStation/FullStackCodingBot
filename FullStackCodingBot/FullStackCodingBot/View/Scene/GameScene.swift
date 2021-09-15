import UIKit
import GameKit
import Firebase

enum GameScene {
    case game(GameViewModel)
    case pause(PauseViewModel)
    case gameOver(GameOverViewModel)
}

extension GameScene {
    
    func instantiate(from identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: identifier, bundle: nil)
        switch self {
        
        case .game(let viewModel):
            guard var gameVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.game) as? GameViewController else {
                Firebase.Analytics.logEvent("ViewControllerError", parameters: nil)
                fatalError()
            }
            gameVC.bind(viewModel: viewModel)
            return gameVC
            
        case .pause(let viewModel):
            guard var pauseVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.pause) as? PauseViewController else {
                Firebase.Analytics.logEvent("ViewControllerError", parameters: nil)
                fatalError()
            }
            pauseVC.bind(viewModel: viewModel)
            return pauseVC
            
        case .gameOver(let viewModel):
            guard var gameOverVC = storyboard.instantiateViewController(withIdentifier: IdentifierVC.gameOver) as? GameOverViewController else {
                Firebase.Analytics.logEvent("ViewControllerError", parameters: nil)
                fatalError()
            }
            gameOverVC.bind(viewModel: viewModel)
            return gameOverVC
            
        }
    }
}
