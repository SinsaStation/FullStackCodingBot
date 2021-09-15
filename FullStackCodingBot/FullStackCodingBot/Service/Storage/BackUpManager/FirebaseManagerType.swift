import Foundation
import RxSwift

protocol FirebaseManagerType {
    
    @discardableResult
    func load(_ uuid: String) -> Observable<NetworkDTO>
    
    func save(_ info: NetworkDTO)
}
