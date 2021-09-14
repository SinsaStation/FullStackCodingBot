import Foundation
import Action
import GameKit

final class RankViewModel: CommonViewModel {
    
    let cancelAction: CocoaAction
    
    init(sceneCoordinator: SceneCoordinatorType, storage: PersistenceStorageType, database: FirebaseManagerType, cancelAction: CocoaAction? = nil) {
        
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, database: database)
    }
}

extension RankViewModel: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        sceneCoordinator.close(animated: true)
    }
}
