import Foundation
import RxSwift

protocol DatabaseManagerType {
    
    @discardableResult
    func getFirebaseData() -> Observable<([Unit], Int)>
    
    func updateDatabase(_ units: [Unit], _ money: Int)
}
