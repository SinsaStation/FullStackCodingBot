import Foundation
import CoreData
import RxSwift

protocol PersistenceStorageType {
    
    @discardableResult
    func append(unit: Unit) -> Observable<Unit>
    
    @discardableResult
    func listUnit() -> Observable<[Unit]>
    
    @discardableResult
    func raiseLevel(of unit: Unit, using moeny: Int) -> Observable<Unit>
    
    @discardableResult
    func availableMoeny() -> Observable<Int>
    
    @discardableResult
    func raiseMoney(by money: Int) -> Observable<Int>
}
