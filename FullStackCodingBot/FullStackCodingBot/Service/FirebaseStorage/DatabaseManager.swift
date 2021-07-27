import Foundation
import RxSwift
import Firebase

final class DatabaseManager: DatabaseManagerType {
    
    private var ref: DatabaseReference
    let data = [Unit]()
    
    init(_ ref: DatabaseReference) {
        self.ref = ref
    }
    
    func initializeDatabase(_ uuid: String) {
        ref.child("users").child(uuid).getData { [unowned self] error, snapshot in
            guard error == nil else { return }
            
            if !snapshot.exists() {
                //let jsonString = DataFormatManager.transformToString(uuid)
                //self.ref.child("users").child(uuid).setValue(["units": jsonString])
            }
        }
    }
    
    func updateDatabase(_ units: [Unit]) {
        let uuid = Auth.auth().currentUser?.uid ?? ""
        let jsonString = DataFormatManager.transformToString(units)
        ref.child("users").child(uuid).setValue(["units": jsonString])
    }
    
    @discardableResult
    func getFirebaseData(_ uuid: String) -> Observable<[Unit]> {
        Observable.create { [unowned self] observer in
            self.ref.child("users").child(uuid).getData { error, snapshot in
                if let error = error {
                    observer.onError(error)
                }
                
                if let data = snapshot.value as? [String: Any] {
                    observer.onNext(DataFormatManager.transformToStruct(data))
                }
            }
            return Disposables.create()
        }
    }
}
