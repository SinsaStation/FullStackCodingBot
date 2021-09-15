import Foundation

// Ad 부분 인터페이스를 나누는 게 나을까?
class AdViewModel: CommonViewModel {
    override init(sceneCoordinator: SceneCoordinatorType, storage: StorageType) {
        super.init(sceneCoordinator: sceneCoordinator, storage: storage)
    }
}
