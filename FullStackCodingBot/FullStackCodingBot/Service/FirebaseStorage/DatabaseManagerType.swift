import Foundation
import RxSwift

protocol DatabaseManagerType {
    
    @discardableResult
    func getFirebaseData(_ uuid: String) -> Observable<[Unit]>
    
    func updateDatabase(_ units: [Unit])
}
