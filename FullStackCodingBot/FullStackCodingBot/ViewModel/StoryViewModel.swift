import Foundation
import RxSwift
import RxCocoa

final class StoryViewModel: AdViewModel {
    
    let storyTimer = BehaviorRelay<Int>(value: 0)
    
    private var settings: SettingInformation
    
    init(sceneCoordinator: SceneCoordinatorType, storage: PersistenceStorageType, adStorage: AdStorageType, database: DatabaseManagerType, settings: SettingInformation) {
        self.settings = settings
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, adStorage: adStorage, database: database)
    }
    
    func makeMoveActionToMain() {
        let mainViewModel = MainViewModel(sceneCoordinator: sceneCoordinator, storage: storage, adStorage: adStorage, database: database, settings: settings)
        let mainScene = Scene.main(mainViewModel)
        self.sceneCoordinator.transition(to: mainScene, using: .root, with: StoryboardType.main, animated: true)
    }
    
    
    func setupStoryTimer() {
        Observable<Int>
            .interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .map { $0 + 1 }
            .subscribe(onNext: { [unowned self] time in
                if time % 4 == 0 {
                    self.storyTimer.accept(storyTimer.value+1)
                }
            }).disposed(by: rx.disposeBag)
    }
}
