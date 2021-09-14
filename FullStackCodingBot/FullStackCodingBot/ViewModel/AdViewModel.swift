import Foundation

class AdViewModel: CommonViewModel {
    
    let adStorage: AdStorageType
    
    init(sceneCoordinator: SceneCoordinatorType, storage: PersistenceStorageType, adStorage: AdStorageType, database: FirebaseManagerType) {
        self.adStorage = adStorage
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, database: database)
    }
}
