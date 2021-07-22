import Foundation
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
            
            if snapshot.exists() {
                print(snapshot.value!)
                print(type(of: snapshot.value!))
            } else {
                self.ref.child("users").child(uuid).setValue(["units": Unit.initialValues()])
            }
        }
    }
}
