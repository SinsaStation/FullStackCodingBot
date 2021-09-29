import Foundation
import RxSwift

protocol BackUpCenterType {
    
    func load(with uuid: String?, _ isFirstLaunched: Bool) -> Observable<NetworkDTO>
    
    func save(gameData newUnit: Unit?, _ newMoney: Int?, _ newScore: Int?)
    
    func save(gameData: NetworkDTO)
    
}
