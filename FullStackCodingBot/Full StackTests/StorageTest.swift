import XCTest
import RxSwift
import RxCocoa
import NSObject_Rx

//class StorageTest: XCTestCase {
//
//    private var mockStorage: MockStorage!
//    private var disposeBag: DisposeBag!
//
//    override func setUpWithError() throws {
//        mockStorage = MockStorage()
//        disposeBag = DisposeBag()
//    }
//
//    override func tearDownWithError() throws {
//    }
//
//    func test_ShouldRaiseMoney() {
//        mockStorage.verifyMoneyMethod(get: 1_000)
//    }
//
//    func test_ShouldRaiseLevel() {
//        let unit = Unit(info: .cPlusPlus, level: 2)
//        let requiredMoney = unit.level * 100
//        mockStorage.verifyLevelupMethod(to: unit, using: requiredMoney)
//    }
//
//    func test_ShouldCreate() {
//        let unit = Unit(info: .cSharp, level: 1)
//        mockStorage.verifyCreatMethod(unit: unit)
//    }
//}
//
//class MockStorage: NSObject, ItemStorageType {
//
//    var availableMoenyMethodCallCount = 0
//    var raiseLevelupMethodCallCount = 0
//    var raiseMoneyMethodCallCount = 0
//    var updateMethodCallCount = 0
//    var createdMethodCallCount = 0
//
//    private var myMoney = 1_000
//    private lazy var moneyStatus = BehaviorSubject<Int>(value: myMoney)
//
//    private var items = [Unit(info: .cPlusPlus, level: 1)]
//    private lazy var store = BehaviorSubject<[Unit]>(value: items)
//
//    // Default Implementation
//    @discardableResult
//    func availableMoeny() -> Observable<Int> {
//        availableMoenyMethodCallCount+=1
//        return moneyStatus
//    }
//
//    @discardableResult
//    func itemList() -> [Unit] {
//        return items
//    }
//
//    @discardableResult
//    func create(item: Unit) -> Observable<Unit> {
//        createdMethodCallCount += 1
//        items.append(item)
//        store.onNext(items)
//        return Observable.just(item)
//    }
//
//    @discardableResult
//    func list() -> Observable<[Unit]> {
//        return store
//    }
//
//    @discardableResult
//    func update(previous: Unit, new: Unit) -> Observable<Unit> {
//        updateMethodCallCount += 1
//        if let index = items.firstIndex(where: { $0 == previous}) {
//            items.remove(at: index)
//            items.insert(new, at: index)
//        }
//        store.onNext(items)
//        return Observable.just(new)
//    }
//
//    @discardableResult
//    func raiseLevel(to unit: Unit, using money: Int) -> Unit {
//        raiseLevelupMethodCallCount += 1
//        let new = Unit(original: unit, level: unit.level+1)
//        update(previous: unit, new: new)
//        myMoney -= money
//        moneyStatus.onNext(myMoney)
//        return new
//    }
//
//    func raiseMoney(by money: Int) {
//        raiseMoneyMethodCallCount += 1
//        myMoney += money
//        moneyStatus.onNext(myMoney)
//    }
//
//    // Test
//    func verifyMoneyMethod(get money: Int) {
//        availableMoeny()
//        XCTAssertEqual(availableMoenyMethodCallCount, 1)
//        raiseMoney(by: money)
//        XCTAssertEqual(raiseMoneyMethodCallCount, 1)
//        XCTAssertEqual(myMoney, 2_000)
//    }
//
//    func verifyLevelupMethod(to unit: Unit, using money: Int) {
//        let updated = raiseLevel(to: unit, using: money)
//        XCTAssertEqual(raiseLevelupMethodCallCount, 1)
//        XCTAssertEqual(updated.level, 3)
//        XCTAssertEqual(updateMethodCallCount, 1)
//        XCTAssertEqual(800, myMoney)
//    }
//
//    func verifyCreatMethod(unit: Unit) {
//        create(item: unit)
//        XCTAssertEqual(createdMethodCallCount, 1)
//        XCTAssertEqual(itemList().count, 2)
//        XCTAssertEqual(itemList().last!, unit)
//    }
//}
