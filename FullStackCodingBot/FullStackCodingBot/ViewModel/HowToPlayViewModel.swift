import Foundation
import RxSwift
import RxCocoa
import Action

final class HowToPlayViewModel: CommonViewModel {
    
    let cancelAction: CocoaAction
    let currentPage = BehaviorRelay<Int>(value: 0)
    let currentManual = BehaviorRelay<Manual>(value: Manual.all[0])
        
    init(sceneCoordinator: SceneCoordinatorType,
         storage: PersistenceStorageType,
         adStorage: AdStorageType,
         database: FirebaseManagerType,
         cancelAction: CocoaAction? = nil) {
        
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, database: database)
    }
    
    func moveToPage(from direction: DirectionType) {
        switch direction {
        case .left:
            guard currentPage.value > 0 else { return }
            currentPage.accept(currentPage.value-1)
        case .right:
            guard currentPage.value < 4 else { return }
            currentPage.accept(currentPage.value+1)
        }
    }
    
    func setCurrentManual() {
        currentPage
            .subscribe(onNext: { current in
                self.currentManual.accept(Manual.all[current])
            }).disposed(by: rx.disposeBag)
    }
}
