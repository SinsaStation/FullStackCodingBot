import Foundation
import RxSwift
import RxCocoa
import Action

class ItemViewModel: CommonViewModel {
    
    let isPossibleToLevelUp = BehaviorRelay<Bool>(value: false)
    
    var itemStorage: Driver<[Unit]> {
        return storage.list().asDriver(onErrorJustReturn: [])
    }
    
    var money: Driver<Int> {
        return storage.availableMoeny().asDriver(onErrorJustReturn: 0)
    }
    
    private var targetUnit: Unit?
    
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
    
    func checkLevelUpPrice(from unit: Unit) {
        targetUnit = unit
        
        storage.availableMoeny()
            .subscribe(onNext: { [unowned self] availableMoney in
                if availableMoney >= (unit.level * 100) {
                    self.isPossibleToLevelUp.accept(true)
                } else {
                    self.isPossibleToLevelUp.accept(false)
                }
            }).disposed(by: rx.disposeBag)
    }
    
    func makeActionLeveUp() {
        if let unit = targetUnit {
            let requiredMoney = unit.level * 100
            storage.raiseLevel(to: unit, using: requiredMoney)
        }
    }
}
