import Foundation
import RxSwift
import RxCocoa
import Action

class ItemViewModel: CommonViewModel {
    
    let isPossibleToLevelUp = BehaviorRelay<Bool>(value: false)
    
    var itemStorage: Driver<[Unit]> {
        return storage.list().asDriver(onErrorJustReturn: [])
    }
    
    var money: Int {
        return storage.availableMoeny()
    }
    
    let cancelAction: CocoaAction
    
    init(sceneCoordinator: SceneCoordinatorType, storage: ItemStorageType, cancelAction: CocoaAction? = nil) {
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        super.init(sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    func checkLevelUpPrice(to level: Int) {
        if (level * 100) <= money {
            isPossibleToLevelUp.accept(true)
        } else {
            isPossibleToLevelUp.accept(false)
        }
    }
}
