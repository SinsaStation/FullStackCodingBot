import Foundation
import Action

final class HowToPlayViewModel: CommonViewModel {
    
    let cancelAction: CocoaAction
    private let manual = Manual.all
    
    init(sceneCoordinator: SceneCoordinatorType,
         storage: PersistenceStorageType,
         adStorage: AdStorageType,
         database: DatabaseManagerType,
         cancelAction: CocoaAction? = nil) {
        
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, database: database)
    }
    
    
    func manualCount() -> Int {
        return manual.count
    }
    
}
