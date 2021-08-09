import Foundation
import RxSwift
import RxCocoa

final class StoryViewModel: AdViewModel {
    
    lazy var script = BehaviorRelay<Script?>(value: storyManager.current())
    private var storyManager: StoryManager
    private var settings: SettingInformation
    
    init(sceneCoordinator: SceneCoordinatorType, storage: PersistenceStorageType, adStorage: AdStorageType, database: DatabaseManagerType, settings: SettingInformation, storyManger: StoryManager = StoryManager()) {
        self.settings = settings
        self.storyManager = storyManger
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, adStorage: adStorage, database: database)
    }
    
    func setupStoryTimer() {
        Observable<Int>
            .interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .map { $0 + 1 }
            .subscribe(onNext: { [unowned self] time in
                let status = storyManager.status(for: time)
                
                switch status {
                case .new(let script):
                    self.script.accept(script)
                case .stay:
                    assert(true)
                case .end:
                    self.makeMoveActionToMain()
                }
            }).disposed(by: rx.disposeBag)
    }
    
    func makeMoveActionToMain() {
        let mainViewModel = MainViewModel(sceneCoordinator: sceneCoordinator, storage: storage, adStorage: adStorage, database: database, settings: settings)
        let mainScene = Scene.main(mainViewModel)
        self.sceneCoordinator.transition(to: mainScene, using: .root, with: StoryboardType.main, animated: true)
    }
}
