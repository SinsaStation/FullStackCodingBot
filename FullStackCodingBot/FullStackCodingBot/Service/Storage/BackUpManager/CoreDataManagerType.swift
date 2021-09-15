import Foundation
import RxSwift

protocol CoreDataManagerType {
    
    @discardableResult
    func setupInitialData() -> Completable
    
    func load() -> NetworkDTO?
    
}
