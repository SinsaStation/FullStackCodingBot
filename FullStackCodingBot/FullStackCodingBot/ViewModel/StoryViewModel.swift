import Foundation
import RxSwift
import RxCocoa

final class StoryViewModel: AdViewModel {
    
    lazy var script = BehaviorRelay<Script?>(value: storyManager.current())
    private var storyManager: StoryManager
    private var settings: SettingInformation
    private let isFirstTimePlay: Bool

    init(sceneCoordinator: SceneCoordinatorType,
         storage: PersistenceStorageType,
         adStorage: AdStorageType,
         database: DatabaseManagerType,
         settings: SettingInformation,
         storyManger: StoryManager = StoryManager(),
         isFirstTimePlay: Bool = true) {
        self.settings = settings
        self.storyManager = storyManger
        self.isFirstTimePlay = isFirstTimePlay
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, adStorage: adStorage, database: database)
    }
    
    func setupStoryTimer() {
        Observable<Int>
            .interval(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
            .map { $0 + 1 }
            .subscribe(onNext: { [unowned self] time in
                let realTime = Double(time) / 10
                let status = storyManager.status(for: realTime)
                
                switch status {
                case .new(let script):
                    self.script.accept(script)
                case .stay:
                    assert(true)
                case .end:
                    self.endOfStory()
                }
            }).disposed(by: rx.disposeBag)
    }
    
    func endOfStory() {
        isFirstTimePlay ? makeMoveActionToMain() : dismiss()
    }
    
    private func makeMoveActionToMain() {
        let mainViewModel = MainViewModel(sceneCoordinator: sceneCoordinator, storage: storage, adStorage: adStorage, database: database, settings: settings)
        let mainScene = MainScene.main(mainViewModel)
        self.sceneCoordinator.transition(to: mainScene, using: .root, with: StoryboardType.main, animated: true)
    }
    
    private func dismiss() {
        self.sceneCoordinator.close(animated: true)
    }
}
