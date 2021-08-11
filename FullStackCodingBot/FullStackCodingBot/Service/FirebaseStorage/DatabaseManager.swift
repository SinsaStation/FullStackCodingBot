import Foundation
import RxSwift
import Firebase

final class DatabaseManager: DatabaseManagerType {
    
    private var ref: DatabaseReference
    private let uid = Auth.auth().currentUser?.uid ?? ""
    private let disposedBag = DisposeBag()
    let data = [Unit]()
    
    init(_ ref: DatabaseReference) {
        self.ref = ref
    }
    
    func updateDatabase(_ info: NetworkDTO) {
        let unitData = try? DataFormatManager.transformToString(info.units)
        let moneyData = try? DataFormatManager.transformToString(info.money)
        let scoreData = try? DataFormatManager.transformToString(info.score)
        let adsData = try? DataFormatManager.transformToString(info.ads)
        ref.child("users").child(uid).setValue(["info": ["units": unitData, "money": moneyData, "score": scoreData, "ads": adsData]])
    }
    
    @discardableResult
    func getFirebaseData() -> Observable<NetworkDTO> {
        Observable.create { [unowned self] observer in
            self.ref.child("users").child(uid).getData { error, snapshot in
                if let error = error {
                    observer.onError(error)
                }
                
                if !snapshot.exists() {
                    let initData = NetworkDTO(units: Unit.initialValues(), money: 0, score: 0, ads: AdsInformation.empty())
                    observer.onNext(initData)
                    observer.onCompleted()
                }
                
                if let data = snapshot.value as? [String: Any] {
                    guard let networkDTO = try? DataFormatManager.transformToLocalData(data) else {
                        return
                    }
                    observer.onNext(networkDTO)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
