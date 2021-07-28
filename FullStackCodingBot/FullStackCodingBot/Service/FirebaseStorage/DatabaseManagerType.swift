import Foundation
import RxSwift

protocol DatabaseManagerType {
    
    @discardableResult
    func getFirebaseData() -> Observable<NetworkDTO>
    
    func updateDatabase(_ units: [Unit], _ money: Int, _ score: Int)
}
