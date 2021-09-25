import Foundation
import RxSwift
import GameKit
import FirebaseAuth

final class LoginManager: NSObject, LoginManagerType {
    
    func getLoginResult() -> Observable<LoginResult> {
        Observable.create { observer in
            var result = LoginResult()
            GKLocalPlayer.local.authenticateHandler = { gcViewController, error in
                
                if let gcViewController = gcViewController {
                    result.gameVC = gcViewController
                    observer.onNext(result)
                    
                } else if let error = error {
                    observer.onError(error)
                    
                } else {
                    GameCenterAuthProvider.getCredential { credential, error in
                        
                        if let error = error {
                            observer.onError(error)
                        }
                        
                        guard let credential = credential else {
                            return
                        }
                        
                        Auth.auth().signIn(with: credential) { user, error in
                            if let error = error {
                                observer.onError(error)
                            }
                            
                            if let user = user {
                                result.uuid = user.user.uid
                                observer.onNext(result)
                                observer.onCompleted()
                            }
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }
}

extension LoginManager: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    }
}
