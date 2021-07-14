import Foundation
import RxSwift

class ItemStorage: ItemStorageType {
    
    private var storage: [Unit] = [
        Unit(info: .cPlusPlus, level: 1),
        Unit(info: .java, level: 1),
        Unit(info: .swift, level: 3),
        Unit(info: .kotlin, level: 1),
        Unit(info: .python, level: 1),
        Unit(info: .cSharp, level: 2),
        Unit(info: .php, level: 1),
        Unit(info: .javaScript, level: 2),
        Unit(info: .ruby, level: 2),
        Unit(info: .theC, level: 1)
    ]
    
    private var myMoney = 200
    
    private lazy var unitStorage = BehaviorSubject(value: storage)
    private lazy var moneyStatue = BehaviorSubject(value: myMoney)
    
    @discardableResult
    func availableMoeny() -> Observable<Int> {
        return moneyStatue
    }
    
    @discardableResult
    func itemList() -> [Unit] {
        return storage
    }
    
    @discardableResult
    func create(item: Unit) -> Observable<Unit> {
        storage.append(item)
        unitStorage.onNext(storage)
        return Observable.just(item)
    }
    
    @discardableResult
    func list() -> Observable<[Unit]> {
        return unitStorage
    }
    
    @discardableResult
    func update(previous: Unit, new: Unit) -> Observable<Unit> {
        if let index = storage.firstIndex(where: { $0 == previous}) {
            storage.remove(at: index)
            storage.insert(new, at: index)
        }
        unitStorage.onNext(storage)
        return Observable.just(new)
    }
    
    @discardableResult
    func raiseLevel(to unit: Unit, using money: Int) -> Unit {
        let new = Unit(original: unit, level: unit.level+1)
        update(previous: unit, new: new)
        myMoney -= money
        moneyStatue.onNext(myMoney)
        return new
    }
}
