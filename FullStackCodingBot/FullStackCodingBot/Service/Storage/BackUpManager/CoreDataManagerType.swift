import Foundation
import RxSwift

protocol CoreDataManagerType {
    
    @discardableResult
    func setupInitialData() -> Completable
    
    func load() -> NetworkDTO?
    
    func save(gameData newUnit: Unit?, _ newMoney: Int?, _ newScore: Int?)

}
