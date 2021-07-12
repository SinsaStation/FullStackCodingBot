import Foundation
import RxSwift
import RxCocoa
import Action

class GameOverViewModel: CommonViewModel {
    
    let cancelAction: CocoaAction
    var finalScore: Int
    
    init(sceneCoordinator: SceneCoordinatorType, storage: ItemStorageType, finalScore: Int, cancelAction: CocoaAction? = nil) {
        self.finalScore = finalScore
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map {_ in}
        }
        super.init(sceneCoordinator: sceneCoordinator, storage: storage)
    }
}
