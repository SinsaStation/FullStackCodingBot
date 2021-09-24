import Foundation

class CommonViewModel: NSObject {
    
    let sceneCoordinator: SceneCoordinatorType
    let storage: StorageType
    
    init(sceneCoordinator: SceneCoordinatorType, storage: StorageType) {
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}
