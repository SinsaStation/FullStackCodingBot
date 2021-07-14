import Foundation
import RxSwift

protocol ItemStorageType {
    
    @discardableResult
    func availableMoeny() -> Observable<Int>
    
    @discardableResult
    func itemList() -> [Unit]
    
    @discardableResult
    func create(item: Unit) -> Observable<Unit>
    
    @discardableResult
    func list() -> Observable<[Unit]>
    
    @discardableResult
    func update(previous: Unit, new: Unit) -> Observable<Unit>
    
    @discardableResult
    func raiseLevel(to unit: Unit, using money: Int) -> Unit
    
    func raiseMoney(by money: Int)
}
