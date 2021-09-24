import Foundation
import RxSwift

final class GameStorage: GameStorageType {
    
    private var unitStore: [Unit] = []
    private lazy var unitList = BehaviorSubject<[Unit]>(value: unitStore)
    private var moneyStore = 0
    private lazy var moneyStatus = BehaviorSubject<Int>(value: moneyStore)
    private var highScore = 0
    
    @discardableResult
    func myHighScore() -> Int {
        return highScore
    }
    
    @discardableResult
    func myMoney() -> Int {
        return moneyStore
    }
    
    @discardableResult
    func itemList() -> [Unit] {
        return unitStore
    }
    
    func update(with data: NetworkDTO) {
        unitStore = data.units
        highScore = data.score
        moneyStore = data.money
    }
    
    @discardableResult
    func update(units: [Unit]) -> Observable<[Unit]> {
        unitStore = filtered(units)
        unitList.onNext(unitStore)
        return Observable.just(units)
    }
    
    private func filtered(_ units: [Unit]) -> [Unit] {
        if units.count == UnitInfo.allCases.count {
            return units
        }
        
        // 1.0.2 #180 중복 유닛 생성 버그 -> 업그레이드된 유닛이 있을 경우 레벨이 높은 유닛으로 storage 생성
        var finalUnits = Unit.initialValues()
        
        units.forEach { unit in
            let currentId = unit.uuid
            let currentLevel = unit.level
            let currentHighestLevel = finalUnits[currentId].level
            if currentLevel >= currentHighestLevel {
                finalUnits[currentId] = unit
            }
        }
        return finalUnits
    }

    @discardableResult
    func listUnit() -> Observable<[Unit]> {
        return unitList
    }
    
    @discardableResult
    func raiseLevel(of unit: Unit, using money: Int) -> Unit {
        let newUnit = Unit(original: unit, level: unit.level+1)
        if let index = unitStore.firstIndex(where: { $0 == unit}) {
            unitStore.remove(at: index)
            unitStore.insert(newUnit, at: index)
            moneyStore -= money
        }
        unitList.onNext(unitStore)
        moneyStatus.onNext(moneyStore)
        return newUnit
    }
    
    @discardableResult
    func availableMoney() -> Observable<Int> {
        return moneyStatus
    }
    
    @discardableResult
    func raiseMoney(by money: Int) -> Observable<Int> {
        moneyStore += money
        moneyStatus.onNext(moneyStore)
        return Observable.just(money)
    }
    
    @discardableResult
    func updateHighScore(new score: Int) -> Bool {
        if score > highScore {
            highScore = score
            return true
        } else {
            return false
        }
    }
}
