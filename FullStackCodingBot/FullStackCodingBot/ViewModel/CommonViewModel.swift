import Foundation

class CommonViewModel: NSObject {
    
    let sceneCoordinator: SceneCoordinatorType
    let storage: PersistenceStorageType
    let database: DatabaseManagerType
    
    init(sceneCoordinator: SceneCoordinatorType, storage: PersistenceStorageType, database: DatabaseManagerType) {
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
        self.database = database
    }
}
