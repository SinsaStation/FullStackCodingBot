import Foundation
import RxSwift
import RxCocoa
import Action

class ItemViewModel: CommonViewModel {
    
    var itemStorage: Driver<[Unit]> {
        return storage.list().asDriver(onErrorJustReturn: [])
    }
    
    let cancelAction: CocoaAction
    
    init(sceneCoordinator: SceneCoordinatorType, storage: ItemStorageType, cancelAction: CocoaAction? = nil) {
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map{ _ in }
        }
        super.init(sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
}
