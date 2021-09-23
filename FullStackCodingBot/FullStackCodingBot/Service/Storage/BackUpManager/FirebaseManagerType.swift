import Foundation
import RxSwift

protocol FirebaseManagerType {
    
    @discardableResult
    func load(with uuid: String) -> Observable<NetworkDTO>
    
    func save(gameData: NetworkDTO)
}
