import Foundation
import RxSwift
import RxCocoa
import Action

class ItemViewModel: CommonViewModel {
    
    private var defaultUnit: Unit {
        return storage.itemList().first!
    }
    
    var itemStorage: Driver<[Unit]> {
        return storage.list().asDriver(onErrorJustReturn: [])
    }
    
    var money: Driver<Int> {
        return storage.availableMoeny().asDriver(onErrorJustReturn: 0)
    }
    
    let isPossibleToLevelUp = BehaviorRelay<Bool>(value: false)
    let cancelAction: CocoaAction
    lazy var selectedUnit = BehaviorRelay<Unit>(value: defaultUnit)
    
    init(sceneCoordinator: SceneCoordinatorType, storage: ItemStorageType, cancelAction: CocoaAction? = nil) {
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        super.init(sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    func checkLevelUpPrice() {
        storage.availableMoeny()
            .subscribe(onNext: { [unowned self] availableMoney in
                if availableMoney >= (selectedUnit.value.level * 100) {
                    self.isPossibleToLevelUp.accept(true)
                } else {
                    self.isPossibleToLevelUp.accept(false)
                }
            }).disposed(by: rx.disposeBag)
    }
    
    func makeActionLeveUp() {
        let requiredMoney = selectedUnit.value.level * 100
        let new = storage.raiseLevel(to: selectedUnit.value, using: requiredMoney)
        selectedUnit.accept(new)
    }
}
