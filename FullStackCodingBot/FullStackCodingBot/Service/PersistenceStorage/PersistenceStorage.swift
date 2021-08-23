import Foundation
import RxSwift
import CoreData
import RxCocoa

final class PersistenceStorage: PersistenceStorageType {
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataStorage")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError()
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
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
    
    @discardableResult
    func update(units: [Unit]) -> Observable<[Unit]> {
        unitStore = filtered(units)
        unitList.onNext(unitStore)
        
        units.forEach { unit in
            try? updateUnit(to: unit)
        }
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
    func raiseLevel(of unit: Unit, using moeny: Int) -> Unit {
        let newUnit = Unit(original: unit, level: unit.level+1)
        if let index = unitStore.firstIndex(where: { $0 == unit}) {
            unitStore.remove(at: index)
            unitStore.insert(newUnit, at: index)
            try? updateUnit(to: newUnit)
            moneyStore -= moeny
            try? updateMoney(money: moneyStore)
        }
        unitList.onNext(unitStore)
        moneyStatus.onNext(moneyStore)
        return newUnit
    }
    
    @discardableResult
    func availableMoeny() -> Observable<Int> {
        return moneyStatus
    }
    
    @discardableResult
    func raiseMoney(by money: Int) -> Observable<Int> {
        moneyStore += money
        moneyStatus.onNext(moneyStore)
        try? updateMoney(money: moneyStore)
        return Observable.just(money)
    }
    
    @discardableResult
    func updateHighScore(new score: Int) -> Bool {
        if score > highScore {
            highScore = score
            try? updateScore(score: highScore)
            return true
        } else {
            return false
        }
    }
    
    @discardableResult
    func getCoreDataInfo() -> Completable {
        let subject = PublishSubject<Void>()
        
        guard let fetchedUnitInfo = try? fetchUnit() else {
            return subject.ignoreElements().asCompletable()
        }
        
        let units = fetchedUnitInfo.map { DataFormatManager.transformToUnit($0) }
        update(units: units)
        
        guard let fetchedMoneyInfo = try? fetchMoneyInfo().first,
              let fetchedScoreInfo = try? fetchScoreInfo().first else {
            return subject.ignoreElements().asCompletable()
        }
        raiseMoney(by: Int(fetchedMoneyInfo.myMoney))
        updateHighScore(new: Int(fetchedScoreInfo.myScore))
        
        subject.onCompleted()
        return subject.ignoreElements().asCompletable()
    }
    
    @discardableResult
    func setupInitialData() -> Completable {
        let subject = PublishSubject<Void>()
        
        let initialUnits = Unit.initialValues()
        update(units: initialUnits)
        
        try? appendUnitInfos(initialUnits)
        try? appendMoenyInfo(0)
        try? appendScoreInfo(0)
        
        subject.onCompleted()
        return subject.ignoreElements().asCompletable()
    }
    
    func lastUpdated() -> Date {
        let farPastDate = Date.init(timeIntervalSince1970: 0)
        guard let fetchedInfo = try? fetchMoneyInfo(),
              let currentMoneyInfo = fetchedInfo.first else {
            return farPastDate
        }
        let lastUpdated = currentMoneyInfo.lastUpdated ?? farPastDate
        return lastUpdated
    }
}

// MARK: CoreData Method
private extension PersistenceStorage {
    private func fetchUnit() throws -> [ItemInformation] {
        do {
            guard let fetchResult = try context.fetch(ItemInformation.fetchRequest()) as? [ItemInformation] else { return [] }
            return fetchResult
        } catch {
            throw CoreDataError.cannotFetchData
        }
    }
    
    private func fetchMoneyInfo() throws -> [MoneyInformation] {
        do {
            guard let fetchResult = try context.fetch(MoneyInformation.fetchRequest()) as? [MoneyInformation] else {
                return [MoneyInformation(context: context)]
            }
            return fetchResult
        } catch {
            throw CoreDataError.cannotFetchData
        }
    }
    
    private func fetchScoreInfo() throws -> [ScoreInformation] {
        do {
            guard let fetchResult = try context.fetch(ScoreInformation.fetchRequest()) as? [ScoreInformation] else {
                return [ScoreInformation(context: context)]
            }
            return fetchResult
        } catch {
            throw CoreDataError.cannotFetchData
        }
    }
    
    private func updateUnit(to unit: Unit) throws {
        guard let fetchedUnit = try? fetchUnit() else { return }
        
        for info in fetchedUnit where info.uuid == unit.uuid {
            info.setValue(unit.uuid, forKey: "uuid")
            info.setValue(unit.image, forKey: "image")
            info.setValue(unit.level, forKey: "level")
        }
        
        do {
            try context.save()
        } catch {
            throw CoreDataError.cannotSaveData
        }
    }
    
    private func updateMoney(money: Int) throws {
        do {
            let previousInfo = try fetchMoneyInfo().first ?? MoneyInformation(context: context)
            previousInfo.setValue(money, forKey: "myMoney")
            previousInfo.setValue(Date(), forKey: "lastUpdated")
            try context.save()
        } catch {
            throw CoreDataError.cannotSaveData
        }
    }
    
    private func updateScore(score: Int) throws {
        do {
            let previousInfo = try fetchScoreInfo().first ?? ScoreInformation(context: context)
            previousInfo.setValue(score, forKey: "myScore")
            try context.save()
        } catch {
            throw CoreDataError.cannotSaveData
        }
    }
    
    private func appendUnitInfos(_ units: [Unit]) throws {
        let fetchedUnit = try? fetchUnit().first
        guard fetchedUnit == nil else { return }
        
        try units.forEach { unit in
            if let entity = NSEntityDescription.entity(forEntityName: "ItemInformation", in: context) {
                let info = NSManagedObject(entity: entity, insertInto: context)
                info.setValue(unit.uuid, forKey: "uuid")
                info.setValue(unit.image, forKey: "image")
                info.setValue(unit.level, forKey: "level")
                
                do {
                    try context.save()
                } catch {
                    throw CoreDataError.cannotSaveData
                }
            }
        }
    }
    
    private func appendMoenyInfo(_ money: Int) throws {
        let fetchedMoney = try? fetchMoneyInfo().first
        guard fetchedMoney == nil else { return }
        
        if let entity = NSEntityDescription.entity(forEntityName: "MoneyInformation", in: context) {
            let info = NSManagedObject(entity: entity, insertInto: context)
            info.setValue(money, forKey: "myMoney")
            info.setValue(Date(), forKey: "lastUpdated")
            
            do {
                try context.save()
            } catch {
                throw CoreDataError.cannotSaveData
            }
        }
        moneyStore = money
        moneyStatus.onNext(moneyStore)
    }
    
    private func appendScoreInfo(_ score: Int) throws {
        let fetchedScore = try? fetchScoreInfo().first
        guard fetchedScore == nil else { return }
        
        if let entity = NSEntityDescription.entity(forEntityName: "ScoreInformation", in: context) {
            let info = NSManagedObject(entity: entity, insertInto: context)
            info.setValue(score, forKey: "myScore")
            
            do {
                try context.save()
            } catch {
                throw CoreDataError.cannotSaveData
            }
        }
    }
}
