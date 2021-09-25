import Foundation
import RxSwift
import GameKit

protocol LoginManagerType {
    func getLoginResult() -> Observable<LoginResult>
}

