import Foundation
import RxSwift

protocol FirebaseManagerType {
    
    @discardableResult
    func getFirebaseData(_ uuid: String) -> Observable<NetworkDTO>
    
    func updateDatabase(_ info: NetworkDTO)
}
