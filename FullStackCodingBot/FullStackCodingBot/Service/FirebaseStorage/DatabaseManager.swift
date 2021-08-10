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
        let unitData = DataFormatManager.transformToString(info.units)
        let moneyData = DataFormatManager.transformToString(info.money)
        let scoreData = DataFormatManager.transformToString(info.score)
        let adsData = DataFormatManager.transformToString(info.ads)
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
                    DataFormatManager.transformToLocalData(data)
                        .subscribe(onNext: { networkDTO in
                            observer.onNext(networkDTO)
                            observer.onCompleted()
                        }, onError: { error in
                            observer.onError(error)
                        }).disposed(by: disposedBag)
                }
            }
            return Disposables.create()
        }
    }
}
