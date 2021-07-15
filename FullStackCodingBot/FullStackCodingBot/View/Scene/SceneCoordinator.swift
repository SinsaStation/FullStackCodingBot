import Foundation
import RxSwift
import RxCocoa

final class SceneCoordinator: SceneCoordinatorType {
    
    private var window: UIWindow
    private var currentVC: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, with type: StoryboardType, animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        let target = scene.instantiate(from: type.name)
        
        switch style {
        case .root:
            currentVC = target
            window.rootViewController = target
            subject.onCompleted()
            
        case .fullScreen:
            target.modalPresentationStyle = .fullScreen
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            currentVC = target
        }
        return subject.ignoreElements().asCompletable()
    }
    
    @discardableResult
    func close(animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        
        if let presentingVC = self.currentVC.presentingViewController {
            self.currentVC.dismiss(animated: animated) {
                self.currentVC = presentingVC
                subject.onCompleted()
            }
        } else {
            subject.onError(TransitionError.unknown)
        }
        
        return subject.ignoreElements().asCompletable()
    }
    
    @discardableResult
    func toMain(animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        
        if let rootVC = window.rootViewController {
            rootVC.dismiss(animated: animated) {
                self.currentVC = rootVC
                subject.onCompleted()
            }
        } else {
            subject.onError(TransitionError.unknown)
        }
        
        return subject.ignoreElements().asCompletable()
    }
}
