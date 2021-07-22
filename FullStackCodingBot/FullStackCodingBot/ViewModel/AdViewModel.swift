import Foundation

class AdViewModel: CommonViewModel {
    
    let adStorage: AdStorageType
    
    init(sceneCoordinator: SceneCoordinatorType, storage: ItemStorageType, adStorage: AdStorageType) {
        self.adStorage = adStorage
        super.init(sceneCoordinator: sceneCoordinator, storage: storage)
    }
}