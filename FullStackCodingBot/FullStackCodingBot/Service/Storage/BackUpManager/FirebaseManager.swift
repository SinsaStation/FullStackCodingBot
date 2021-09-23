import Foundation
import RxSwift
import Firebase

final class FirebaseManager: FirebaseManagerType {
    
    private var ref: DatabaseReference
    private let uid = Auth.auth().currentUser?.uid ?? ""
    private let disposedBag = DisposeBag()
    
    enum Keys {
        static let users = "users"
        static let info = "info"
        static let units = "units"
        static let money = "money"
        static let score = "score"
        static let ads = "ads"
        static let date = "date"
    }
    
    init(_ ref: DatabaseReference = Database.database().reference()) {
        self.ref = ref
    }
    
    func save(_ info: NetworkDTO) {
        guard uid != "" else { return }
        
        let unitData = try? DataFormatManager.transformToString(info.units)
        let moneyData = try? DataFormatManager.transformToString(info.money)
        let scoreData = try? DataFormatManager.transformToString(info.score)
        let adsData = try? DataFormatManager.transformToString(info.ads)
        let recentDate = try? DataFormatManager.transformToString(info.date)
        
        ref.child(Keys.users).child(uid).setValue([Keys.info: [Keys.units: unitData,
                                                               Keys.money: moneyData,
                                                               Keys.score: scoreData,
                                                               Keys.ads: adsData,
                                                               Keys.date: recentDate]])
    }
    
    @discardableResult
    func load(_ uuid: String) -> Observable<NetworkDTO> {
        Observable.create { [unowned self] observer in
            self.ref.child(Keys.users).child(uuid).getData { error, snapshot in
                if let error = error {
                    observer.onError(error)
                }
                
                if !snapshot.exists() {
                    let initData = NetworkDTO(units: Unit.initialValues(), money: 0, score: 0, ads: AdsInformation.empty(), date: Date.init(timeIntervalSince1970: 0))
                    observer.onNext(initData)
                    observer.onCompleted()
                }
                
                if let data = snapshot.value as? [String: Any] {
                    DataFormatManager.transformToLocalData(data)
                        .subscribe(onNext: { networkDTO in
                            observer.onNext(networkDTO)
                            observer.onCompleted()
                        }).disposed(by: disposedBag)
                }
            }
            return Disposables.create()
        }
    }
}
