import Foundation
import RxSwift
import RxCocoa

final class PauseViewModel: CommonViewModel {

    private let currentScore = BehaviorRelay<Int>(value: 0)
    private var newGameStatus: BehaviorRelay<GameStatus>
    
    lazy var currentScoreInfo: Driver<String> = {
        return currentScore.map {String($0)}.asDriver(onErrorJustReturn: "")
    }()
    
    init(sceneCoordinator: SceneCoordinatorType, currentScore: Int, newGameStatus: BehaviorRelay<GameStatus>) {
        self.newGameStatus = newGameStatus
        self.currentScore.accept(currentScore)
        super.init(sceneCoordinator: sceneCoordinator)
    }
    
    func makeMoveAction(to viewController: PauseActionType) {
        switch viewController {
        case .resume:
            newGameStatus.accept(.resume)
            sceneCoordinator.close(animated: false)
        case .restart:
            newGameStatus.accept(.ready)
            sceneCoordinator.close(animated: false)
        case .toMain:
            sceneCoordinator.toMain(animated: false)
            MusicStation.shared.play(type: .main)
        }
    }
}
