import Foundation

class CommonViewModel: NSObject {
    
    let sceneCoordinator: SceneCoordinatorType
    let storage: ItemStorageType
    let database: DatabaseManagerType
    
    init(sceneCoordinator: SceneCoordinatorType, storage: ItemStorageType, database: DatabaseManagerType) {
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
        self.database = database
    }
}
