import Foundation

class CommonViewModel:NSObject {
    
    let sceneCoordinator: SceneCoordinatorType
    let storage: ItemStorageType
    
    init(sceneCoordinator: SceneCoordinatorType, storage:ItemStorageType) {
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}
