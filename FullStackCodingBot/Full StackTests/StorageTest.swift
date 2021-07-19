import XCTest
import RxSwift
import RxCocoa

class StorageTest: XCTestCase {
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testExample() throws {
    }

    func testPerformanceExample() throws {
    }

}

class MockStorage: ItemStorageType {
    
    private var myMoney = 1_000
    private lazy var moneyStatus = BehaviorSubject<Int>(value: myMoney)
    
    private var items = [Unit(info: .cPlusPlus, level: 1)]
    private lazy var store = BehaviorSubject<[Unit]>(value: items)
    
    @discardableResult
    func availableMoeny() -> Observable<Int> {
        return moneyStatus
    }
    
    @discardableResult
    func itemList() -> [Unit] {
        return items
    }
    
    @discardableResult
    func create(item: Unit) -> Observable<Unit> {
        items.append(item)
        store.onNext(items)
        return Observable.just(item)
    }
    
    @discardableResult
    func list() -> Observable<[Unit]> {
        return store
    }
    
    @discardableResult
    func update(previous: Unit, new: Unit) -> Observable<Unit> {
        if let index = items.firstIndex(where: { $0 == previous}) {
            items.remove(at: index)
            items.insert(new, at: index)
        }
        store.onNext(items)
        return Observable.just(new)
    }
    
    @discardableResult
    func raiseLevel(to unit: Unit, using money: Int) -> Unit {
        let new = Unit(original: unit, level: unit.level+1)
        update(previous: unit, new: new)
        myMoney -= money
        moneyStatus.onNext(myMoney)
        return new
    }
    
    func raiseMoney(by money: Int) {
        myMoney += money
        moneyStatus.onNext(myMoney)
    }
}
