import Foundation
import RxSwift
import GameKit

final class LoginManager: NSObject {
    
}

extension LoginManager: GKGameCenterControllerDelegate, LoginManagerType {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    }
    
    func getLoginResult() -> Observable<LoginResult> {
    }
}
