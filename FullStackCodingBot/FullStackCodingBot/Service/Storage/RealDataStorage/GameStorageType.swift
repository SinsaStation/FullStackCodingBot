import Foundation
import RxSwift

protocol GameStorageType {
    
    @discardableResult
    func myHighScore() -> Int
    
    @discardableResult
    func myMoney() -> Int
    
    @discardableResult
    func itemList() -> [Unit]
    
    func update(with data: NetworkDTO)
    
    @discardableResult
    func listUnit() -> Observable<[Unit]>
    
    @discardableResult
    func raiseLevel(of unit: Unit, using money: Int) -> Unit
    
    @discardableResult
    func availableMoney() -> Observable<Int>
    
    @discardableResult
    func raiseMoney(by money: Int) -> Observable<Int>
    
    @discardableResult
    func updateHighScore(new score: Int) -> Bool
}
