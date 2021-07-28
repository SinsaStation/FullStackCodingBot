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
    
    var selectedUnit = BehaviorRelay<Unit>(value: Unit(info: .swift, level: 1))
    
    private var unitStore: [Unit] = []
    private lazy var unitList = BehaviorSubject<[Unit]>(value: unitStore)
    private var moneyStore = 0
    private lazy var moneyStatus = BehaviorSubject<Int>(value: moneyStore)
        
    func didLoaded() {
        selectedUnit.accept(unitStore.first!)
    }
    
    @discardableResult
    func myMoney() -> Int {
        return moneyStore
    }
    
    @discardableResult
    func itemList() -> [Unit] {
        return unitStore
    }
    
    func initializeData(_ units: [Unit], _ money: Int) {
        units.forEach { append(unit: $0) }
        appendMoenyInfo(money)
    }
    
    func fetchStoredData() {
        for info in fetchUnit() {
            unitStore.append(DataFormatManager.transformToUnit(info))
        }
        unitStore.sort(by: { $0.uuid < $1.uuid })
        unitList.onNext(unitStore)
        moneyStore = fetchMoneyInfo().map { DataFormatManager.transformToMoney($0) }.first ?? 0
        moneyStatus.onNext(moneyStore)
    }
    
    @discardableResult
    func append(unit: Unit) -> Observable<Unit> {
        unitStore.append(unit)
        addItemInfo(from: unit)
        unitList.onNext(unitStore)
        return Observable.just(unit)
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
            updateUnit(to: newUnit)
            moneyStore -= moeny
            updateMoney(money: moneyStore)
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
        updateMoney(money: money)
        return Observable.just(money)
    }
    
    private func deleteUnit(unit: Unit) {
        if let shouldBeRemoved = fetchUnit().filter({ $0.uuid == unit.uuid}).first {
            context.delete(shouldBeRemoved)
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    private func fetchUnit() -> [ItemInformation] {
        do {
            guard let fetchResult = try context.fetch(ItemInformation.fetchRequest()) as? [ItemInformation] else { return [] }
            return fetchResult
        } catch {
            print(error)
            return []
        }
    }
    
    private func addItemInfo(from unit: Unit) {
        if let entity = NSEntityDescription.entity(forEntityName: "ItemInformation", in: context) {
            let info = NSManagedObject(entity: entity, insertInto: context)
            info.setValue(unit.uuid, forKey: "uuid")
            info.setValue(unit.image, forKey: "image")
            info.setValue(unit.level, forKey: "level")
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateUnit(to unit: Unit) {
        for info in fetchUnit() where info.uuid == unit.uuid {
            info.setValue(unit.uuid, forKey: "uuid")
            info.setValue(unit.image, forKey: "image")
            info.setValue(unit.level, forKey: "level")
        }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private func updateMoney(money: Int) {
        do {
            guard let previousInfo = fetchMoneyInfo().first else { return }
            previousInfo.setValue(money, forKey: "myMoney")
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private func fetchMoneyInfo() -> [MoneyInformation] {
        do {
            guard let fetchResult = try context.fetch(MoneyInformation.fetchRequest()) as? [MoneyInformation] else {
                return []
            }
            print("MONEY: ", fetchResult)
            return fetchResult
        } catch {
            print(error)
            return []
        }
    }
    
    private func appendMoenyInfo(_ money: Int) {
        if let entity = NSEntityDescription.entity(forEntityName: "MoneyInformation", in: context) {
            let info = NSManagedObject(entity: entity, insertInto: context)
            info.setValue(money, forKey: "myMoney")
            
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
        moneyStore = money
        moneyStatus.onNext(moneyStore)
    }
}
