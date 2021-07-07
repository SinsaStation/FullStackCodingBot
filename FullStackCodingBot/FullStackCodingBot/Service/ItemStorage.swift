import Foundation
import RxSwift

class ItemStorage: ItemStorageType {
    
    private var storage: [Unit] = [
        // DummyData
        Unit(uuid: 0, image: .cPlusPlus, level: 1, count: 1),
        Unit(uuid: 1, image: .java, level: 1, count: 1),
        Unit(uuid: 2, image: .kotlin, level: 1, count: 1),
        Unit(uuid: 3, image: .swift, level: 1, count: 1)
    ]
    
    private lazy var unitStorage = BehaviorSubject(value: storage)
    
    @discardableResult
    func create(item: Unit) -> Observable<Unit> {
        storage.append(item)
        unitStorage.onNext(storage)
        return Observable.just(item)
    }
    
    @discardableResult
    func list() -> Observable<[Unit]> {
        return unitStorage.asObservable()
    }
    
    @discardableResult
    func update(previous: Unit, new: Unit) -> Observable<Unit> {
        if let index = storage.firstIndex(where: { $0.uuid == previous.uuid}) {
            storage.remove(at: index)
            storage.insert(new, at: index)
        }
        unitStorage.onNext(storage)
        return Observable.just(new)
    }
}
