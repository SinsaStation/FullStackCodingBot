import Foundation
import CoreData
import RxSwift

protocol PersistenceStorageType {
    
    func initializeData(_ units: [Unit], _ money: Int)
    
    func fetchStoredData()
    
    @discardableResult
    func myMoney() -> Int
    
    @discardableResult
    func itemList() -> [Unit]
    
    @discardableResult
    func append(unit: Unit) -> Observable<Unit>
    
    @discardableResult
    func listUnit() -> Observable<[Unit]>
    
    @discardableResult
    func raiseLevel(of unit: Unit, using moeny: Int) -> Unit
    
    @discardableResult
    func availableMoeny() -> Observable<Int>
    
    @discardableResult
    func raiseMoney(by money: Int) -> Observable<Int>
}
