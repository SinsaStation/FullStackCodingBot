import Foundation
import RxSwift

protocol BackUpCenterType {
    
    func load(with uuid: String?, _ isFirstLaunched: Bool) -> Observable<NetworkDTO>
    
    func save(_ newUnit: Unit?, _ newMoney: Int?, _ newScore: Int?)
    
    func save(_ info: NetworkDTO)
    
}
