import Foundation
import RxSwift
import CoreData

class ItemStorage: ItemStorageType {
    
    // swiftlint:disable force_cast
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appDelegate.persistentContainer.viewContext
    private lazy var entity = NSEntityDescription.entity(forEntityName: "ItemInformation", in: context)
    
    private var storage: [Unit] = []
    
    private var myMoney = 200000000
    
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
        if let entity = entity {
            let info = NSManagedObject(entity: entity, insertInto: context)
            info.setValue(item.uuid, forKey: "uuid")
            info.setValue(item.image, forKey: "image")
            info.setValue(item.level, forKey: "level")
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
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
    
    func raiseMoney(by money: Int) {
        myMoney += money
        moneyStatue.onNext(myMoney)
    }
}
