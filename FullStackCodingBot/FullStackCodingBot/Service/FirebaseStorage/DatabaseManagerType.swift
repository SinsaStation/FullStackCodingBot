import Foundation
import RxSwift

protocol DatabaseManagerType {
    
    @discardableResult
    func getFirebaseData(_ uuid: String) -> Observable<NetworkDTO>
    
    func updateDatabase(_ info: NetworkDTO)
}
