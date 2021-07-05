import Foundation
import RxSwift
import RxCocoa

class SceneCoordinator: SceneCoordinatorType {
    
    private let bag = DisposeBag()
    private var window: UIWindow
    private var currentVC: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        <#code#>
    }
    
    func close(animated: Bool) -> Completable {
        <#code#>
    }
    
    
}
