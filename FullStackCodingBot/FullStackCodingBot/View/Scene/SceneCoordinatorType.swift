import Foundation
import RxSwift

protocol SceneCoordinatorType {
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, with type: StoryboardType, animated: Bool) -> Completable
    
    @discardableResult
    func close(animated: Bool) -> Completable
    
    @discardableResult
    func toMain(animated: Bool) -> Completable
    
}
