import Foundation
import Action

final class ShopViewModel: CommonViewModel {
    
    let confirmAction: Action<String, Void>
    let cancelAction: CocoaAction
    
    init(sceneCoordinator: SceneCoordinatorType, storage: ItemStorageType, database: DatabaseManagerType, confirmAction: Action<String, Void>? = nil, cancelAction: CocoaAction? = nil) {
        
        self.confirmAction = Action<String, Void> { input in
            if let action = confirmAction {
                action.execute(input)
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, database: database)
    }
}
