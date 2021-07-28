import Foundation
import RxSwift
import Firebase

final class DatabaseManager: DatabaseManagerType {
    
    private var ref: DatabaseReference
    private let uid = Auth.auth().currentUser?.uid ?? ""
    let data = [Unit]()
    
    init(_ ref: DatabaseReference) {
        self.ref = ref
    }
    
    func updateDatabase(_ units: [Unit], _ money: Int, _ score: Int) {
        let unitData = DataFormatManager.transformToString(units)
        let moneyData = DataFormatManager.transformToString(money)
        let scoreData = DataFormatManager.transformToString(score)
        ref.child("users").child(uid).setValue(["info": ["units": unitData, "money": moneyData, "score": scoreData]])
    }
    
    @discardableResult
    func getFirebaseData() -> Observable<NetworkDTO> {
        Observable.create { [unowned self] observer in
            self.ref.child("users").child(uid).getData { error, snapshot in
                if let error = error {
                    observer.onError(error)
                }
                
                if let data = snapshot.value as? [String: Any] {
                    observer.onNext(DataFormatManager.transformToLocalData(data))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
