import Foundation
import RxSwift

protocol DatabaseManagerType {
    
    @discardableResult
    func getFirebaseData() -> Observable<NetworkDTO>
    
    func updateDatabase(_ info: NetworkDTO)
}
