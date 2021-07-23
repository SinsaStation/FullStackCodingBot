import Foundation
import RxSwift
import RxCocoa
import Action

final class ItemViewModel: CommonViewModel {
    
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
    lazy var status = BehaviorRelay<String>(value: Text.levelUp)
    lazy var upgradedUnit = BehaviorRelay<Unit?>(value: nil)
    private var feedbackGenerator: UINotificationFeedbackGenerator?
    
    init(sceneCoordinator: SceneCoordinatorType, storage: ItemStorageType, database: DatabaseManagerType, cancelAction: CocoaAction? = nil) {
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, database: database)
        setupFeedbackGenerator()
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
        let unitName = selectedUnit.value.image
        let requiredMoney = selectedUnit.value.level * 100
        
        switch isPossibleToLevelUp.value {
        case true:
            let new = storage.raiseLevel(to: selectedUnit.value, using: requiredMoney)
            selectedUnit.accept(new)
            upgradedUnit.accept(new)
            status.accept(Text.levelUpSuccessed(unitType: unitName, to: new.level))
        case false:
            status.accept(Text.levelUpFailed(coinNeeded: requiredMoney))
            feedbackGenerator?.notificationOccurred(.error)
        }
    }
    
    private func setupFeedbackGenerator() {
        feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator?.prepare()
    }
}
