import Foundation
import RxSwift
import RxCocoa
import Action

final class ItemViewModel: CommonViewModel {
    
    var defaultUnit: Unit {
        return storage.itemList().first!
    }
    
    var itemStorage: Driver<[Unit]> {
        return storage.listUnit().asDriver(onErrorJustReturn: [])
    }
    
    var money: Driver<Int> {
        return storage.availableMoeny().asDriver(onErrorJustReturn: 0)
    }
    
    let isPossibleToLevelUp = BehaviorRelay<Bool>(value: false)
    let cancelAction: CocoaAction
    lazy var selectedUnit = BehaviorRelay<Unit>(value: defaultUnit)
    lazy var levelUpStatus = BehaviorRelay<LevelUpStatus>(value: .info)
    lazy var upgradedUnit = BehaviorRelay<Unit?>(value: nil)
    private let soundEffectStation: SingleSoundEffectStation
    
    init(sceneCoordinator: SceneCoordinatorType,
         storage: PersistenceStorageType,
         database: FirebaseManagerType,
         cancelAction: CocoaAction? = nil,
         soundEffectType: MainSoundEffect = .upgrade) {
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        self.soundEffectStation = SingleSoundEffectStation(soundEffectType: soundEffectType)
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, database: database)
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
        let targetUnit = selectedUnit.value
        let requiredMoney = targetUnit.level * 100
        
        switch isPossibleToLevelUp.value {
        case true:
            let new = storage.raiseLevel(of: targetUnit, using: requiredMoney)
            selectedUnit.accept(new)
            upgradedUnit.accept(new)
            levelUpStatus.accept(.success(new))
            soundEffectStation.play()
        case false:
            levelUpStatus.accept(.fail(requiredMoney))
        }
    }
}
