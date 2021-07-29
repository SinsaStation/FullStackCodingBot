import UIKit
import GameKit

final class RankViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: RankViewModel!
    @IBOutlet weak var cancelButton: UIButton!
    let gameVC = GKGameCenterViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameVC.gameCenterDelegate = self
        gameVC.viewState = .dashboard
        gameVC.leaderboardIdentifier = "WeeklyScore"
        present(gameVC, animated: true, completion: nil)
    }
    
    func bindViewModel() {
        cancelButton.rx.action = viewModel.cancelAction
    }
}

extension RankViewController: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameVC.dismiss(animated: true, completion: nil)
    }
}
