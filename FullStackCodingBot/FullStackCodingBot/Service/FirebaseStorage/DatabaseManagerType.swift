import Foundation
import RxSwift

protocol DatabaseManagerType {
    
    func initializeDatabase(_ uuid: String)
    
    @discardableResult
    func getFirebaseData(_ uuid: String) -> Observable<[Unit]>
}
