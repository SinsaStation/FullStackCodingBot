import Foundation
import RxSwift
import RxCocoa
import Action

final class PauseViewModel: CommonViewModel {

    private let currentScore = BehaviorRelay<Int>(value: 0)
    private var newGameStatus: BehaviorRelay<GameStatus>
    
    lazy var currentScoreInfo: Driver<String> = {
        return currentScore.map {String($0)}.asDriver(onErrorJustReturn: "")
    }()
    
    init(sceneCoordinator: SceneCoordinatorType, storage: PersistenceStorageType, database: DatabaseManagerType, currentScore: Int, newGameStatus: BehaviorRelay<GameStatus>) {
        self.newGameStatus = newGameStatus
        self.currentScore.accept(currentScore)
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, database: database)
    }
    
    func makeMoveAction(to viewController: PauseActionType) {
        switch viewController {
        case .resume:
            newGameStatus.accept(.resume)
            sceneCoordinator.close(animated: true)
        case .restart:
            newGameStatus.accept(.ready)
            sceneCoordinator.close(animated: true)
        case .toMain:
            sceneCoordinator.toMain(animated: true)
        }
    }
}
