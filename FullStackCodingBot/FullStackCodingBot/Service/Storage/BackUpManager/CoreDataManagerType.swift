import Foundation
import RxSwift

protocol CoreDataManagerType {
    
    @discardableResult
    func setupInitialData() -> Completable
    
    func load() -> NetworkDTO?
    
    func save(_ newUnit: Unit?, _ newMoney: Int?, _ newScore: Int?)

}
