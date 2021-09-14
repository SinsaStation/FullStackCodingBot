import Foundation
import RxSwift

protocol BackUpCenterType {
    func load(with uuid: String?, _ isFirstLaunched: Bool) -> Observable<NetworkDTO>
}
