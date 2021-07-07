import Foundation
import RxSwift
import RxCocoa
import Action

class GameViewModel: CommonViewModel {
    
    let logic = BehaviorRelay<Direction?>(value: nil)
    
    var itemStorage: Observable<[Unit]> {
        return storage.list()
    }
    
    let cancelAction: CocoaAction
    
    init(sceneCoordinator: SceneCoordinatorType, storage: ItemStorageType, cancelAction: CocoaAction? = nil) {
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map {_ in}
        }
        super.init(sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    func moveUnitAction(to direction: Direction) {
        switch direction {
        case .left: logic.accept(.left)
        case .right: logic.accept(.right)
        }
    }
    
    func generateStartingUnits() -> [Unit] {
        return (0..<Perspective.count).map { storage.itemList()[$0 % 10] }
    }
    
    func newRandomUnit() -> Unit {
        return storage.itemList().randomElement()!
    }
}
