import Foundation
import CoreData
import RxSwift

final class CoreDataManager: CoreDataManagerType {
    
    private let storageKey = "CoreDataStorage"
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: storageKey)
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
    
    enum Entity {
        static let item = "ItemInformation"
        static let money = "MoneyInformation"
        static let score = "ScoreInformation"
    }
    
    enum Keys {
        static let uuid = "uuid"
        static let image = "image"
        static let level = "level"
        static let myMoney = "myMoney"
        static let lastUpdated = "lastUpdated"
        static let myScore = "myScore"
    }
    
    @discardableResult
    func setupInitialData() -> Completable {
        let subject = PublishSubject<Void>()
        let initialUnits = Unit.initialValues()
        
        do {
            try appendUnitInfos(initialUnits)
            try appendMoneyInfo(0)
            try appendScoreInfo(0)
        } catch {
            subject.onError(CoreDataError.cannotFetchData)
        }
        subject.onCompleted()
        return subject.ignoreElements().asCompletable()
    }
    
    func load() -> NetworkDTO? {
        guard let fetchedUnitInfo = try? self.fetchUnit(),
              let fetchedMoneyInfo = try? self.fetchMoneyInfo().first,
              let fetchedScoreInfo = try? self.fetchScoreInfo().first else {
            return nil
        }
        
        let units = fetchedUnitInfo.map { DataFormatManager.transformToUnit($0) }
        let money = Int(fetchedMoneyInfo.myMoney)
        let score = Int(fetchedScoreInfo.myScore)
        let date = fetchedMoneyInfo.lastUpdated ?? .init(timeIntervalSince1970: 0)
        let localData = NetworkDTO.init(units: units,
                                        money: money,
                                        score: score,
                                        ads: .empty(),
                                        date: date)
        return localData
    }
    
    func save(gameData newUnit: Unit?, _ newMoney: Int?, _ newScore: Int?) {
        if let newUnit = newUnit {
            try? updateUnit(to: newUnit)
        }
        
        if let newMoney = newMoney {
            try? updateMoney(money: newMoney)
        }
        
        if let newScore = newScore {
            try? updateScore(score: newScore)
        }
    }
}

// MARK: new
extension CoreDataManager {
    private func appendUnitInfos(_ units: [Unit]) throws {
        let fetchedUnit = try? fetchUnit().first
        guard fetchedUnit == nil else { return }
        
        try units.forEach { unit in
            if let entity = NSEntityDescription.entity(forEntityName: Entity.item, in: context) {
                let info = NSManagedObject(entity: entity, insertInto: context)
                info.setValue(unit.uuid, forKey: Keys.uuid)
                info.setValue(unit.image, forKey: Keys.image)
                info.setValue(unit.level, forKey: Keys.level)
                
                do {
                    try context.save()
                } catch {
                    throw CoreDataError.cannotSaveData
                }
            }
        }
    }
    
    private func appendMoneyInfo(_ money: Int) throws {
        let fetchedMoney = try? fetchMoneyInfo().first
        guard fetchedMoney == nil else { return }
        
        if let entity = NSEntityDescription.entity(forEntityName: Entity.money, in: context) {
            let info = NSManagedObject(entity: entity, insertInto: context)
            info.setValue(money, forKey: Keys.myMoney)
            info.setValue(Date.init(timeIntervalSince1970: 0), forKey: Keys.lastUpdated)
            
            do {
                try context.save()
            } catch {
                throw CoreDataError.cannotSaveData
            }
        }
    }
    
    private func appendScoreInfo(_ score: Int) throws {
        let fetchedScore = try? fetchScoreInfo().first
        guard fetchedScore == nil else { return }
        
        if let entity = NSEntityDescription.entity(forEntityName: Entity.score, in: context) {
            let info = NSManagedObject(entity: entity, insertInto: context)
            info.setValue(score, forKey: Keys.myScore)
            
            do {
                try context.save()
            } catch {
                throw CoreDataError.cannotSaveData
            }
        }
    }
}

// MARK: load
extension CoreDataManager {
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
}

// MARK: save
extension CoreDataManager {
    private func updateUnit(to unit: Unit) throws {
        guard let fetchedUnit = try? fetchUnit() else { return }
        
        for info in fetchedUnit where info.uuid == unit.uuid {
            info.setValue(unit.uuid, forKey: Keys.uuid)
            info.setValue(unit.image, forKey: Keys.image)
            info.setValue(unit.level, forKey: Keys.level)
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
            previousInfo.setValue(money, forKey: Keys.myMoney)
            previousInfo.setValue(Date(), forKey: Keys.lastUpdated)
            try context.save()
        } catch {
            throw CoreDataError.cannotSaveData
        }
    }
    
    private func updateScore(score: Int) throws {
        do {
            let previousInfo = try fetchScoreInfo().first ?? ScoreInformation(context: context)
            previousInfo.setValue(score, forKey: Keys.myScore)
            try context.save()
        } catch {
            throw CoreDataError.cannotSaveData
        }
    }
}
