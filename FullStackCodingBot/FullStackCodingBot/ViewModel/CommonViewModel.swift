import Foundation

class CommonViewModel: NSObject {
    
    let sceneCoordinator: SceneCoordinatorType
    let storage: PersistenceStorageType
    let database: FirebaseManagerType
    
    init(sceneCoordinator: SceneCoordinatorType, storage: PersistenceStorageType, database: FirebaseManagerType) {
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
        self.database = database
    }
}
