import XCTest
import RxSwift
import RxCocoa
import NSObject_Rx

class StorageTest: XCTestCase {

    private var mockStorage: MockStorage!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        mockStorage = MockStorage()
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
    }

    func test_ShouldRaiseMoney() {
        mockStorage.verifyMoneyMethod(get: 1_000)
    }

    func test_ShouldRaiseLevel() {
        let unit = Unit(info: .cPlusPlus, level: 1)
        let requiredMoney = unit.level * 100
        mockStorage.verifyLevelupMethod(to: unit, using: requiredMoney)
    }

    func test_ShouldCreate() {
        let unit = Unit(info: .cSharp, level: 1)
        mockStorage.verifyCreatMethod(unit: unit)
    }
}

class MockStorage: NSObject, PersistenceStorageType {
    
    // Test Property
    var availableMoenyMethodCallCount = 0
    var raiseLevelupMethodCallCount = 0
    var raiseMoneyMethodCallCount = 0
    var updateMethodCallCount = 0
    var createdMethodCallCount = 0

    private var money = 1_000
    private lazy var moneyStatus = BehaviorSubject<Int>(value: money)

    private var items = [Unit(info: .cPlusPlus, level: 1)]
    private lazy var store = BehaviorSubject<[Unit]>(value: items)
    
    
    private var highScore = 1_000
    // Default Implemantation
    
    @discardableResult
    func myHighScore() -> Int {
        return highScore
    }
    
    @discardableResult
    func myMoney() -> Int {
        return money
    }
    
    @discardableResult
    func itemList() -> [Unit] {
        return items
    }
    
    @discardableResult
    func append(unit: Unit) -> Observable<Unit> {
        items.append(unit)
        store.onNext(items)
        return Observable.just(unit)
    }
    
    @discardableResult
    func listUnit() -> Observable<[Unit]> {
        return store
    }
    
    @discardableResult
    func raiseLevel(of unit: Unit, using moeny: Int) -> Unit {
        let newUnit = Unit(original: unit, level: unit.level+1)
        if let index = items.firstIndex(where: { $0 == unit}) {
            items.remove(at: index)
            items.insert(newUnit, at: index)
            self.money -= moeny
        }
        store.onNext(items)
        moneyStatus.onNext(self.money)
        return newUnit
    }
    
    @discardableResult
    func availableMoeny() -> Observable<Int> {
        moneyStatus
    }
    
    @discardableResult
    func raiseMoney(by money: Int) -> Observable<Int> {
        self.money += money
        moneyStatus.onNext(self.money)
        return Observable.just(money)
    }
    
    @discardableResult
    func updateHighScore(new score: Int) -> Bool {
        if score > highScore {
            highScore = score
            return true
        }
        return false
    }
    
    // Test
    func verifyMoneyMethod(get money: Int) {
        availableMoeny()
        XCTAssertEqual(availableMoenyMethodCallCount, 1)
        raiseMoney(by: money)
        XCTAssertEqual(raiseMoneyMethodCallCount, 1)
        XCTAssertEqual(self.money, 2_000)
    }

    func verifyLevelupMethod(to unit: Unit, using money: Int) {
        let updated = raiseLevel(of: unit, using: money)
        XCTAssertEqual(raiseLevelupMethodCallCount, 1)
        XCTAssertEqual(updated.level, 3)
        XCTAssertEqual(updateMethodCallCount, 1)
        XCTAssertEqual(800, self.money)
    }

    func verifyCreatMethod(unit: Unit) {
        append(unit: unit)
        XCTAssertEqual(createdMethodCallCount, 1)
        XCTAssertEqual(itemList().count, 2)
        XCTAssertEqual(itemList().last!, unit)
    }
}
