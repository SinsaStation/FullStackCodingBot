import Foundation
import Action

class GiftViewModel: CommonViewModel {
    
    
    let cancelAction: CocoaAction
    
    init(sceneCoordinator: SceneCoordinatorType, cancelAction: CocoaAction? = nil) {
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map{ _ in }
        }
        
        super.init(sceneCoordinator: sceneCoordinator)
    }
}
