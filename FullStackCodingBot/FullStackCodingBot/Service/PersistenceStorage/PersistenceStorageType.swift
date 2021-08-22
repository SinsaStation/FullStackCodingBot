import Foundation
import CoreData
import RxSwift
import RxCocoa

protocol PersistenceStorageType {
    
    @discardableResult
    func myHighScore() -> Int
    
    @discardableResult
    func myMoney() -> Int
    
    @discardableResult
    func itemList() -> [Unit]
    
    @discardableResult
    func append(unit: Unit) -> Observable<Unit>
    
    @discardableResult
    func listUnit() -> Observable<[Unit]>
    
    @discardableResult
    func raiseLevel(of unit: Unit, using moeny: Int) -> Unit
    
    @discardableResult
    func availableMoeny() -> Observable<Int>
    
    @discardableResult
    func raiseMoney(by money: Int) -> Observable<Int>
    
    @discardableResult
    func updateHighScore(new score: Int) -> Bool
    
    @discardableResult
    func getCoreDataInfo() -> Completable
    
    @discardableResult
    func setupInitialData() -> Completable
    
    func lastUpdated() -> Date
}
