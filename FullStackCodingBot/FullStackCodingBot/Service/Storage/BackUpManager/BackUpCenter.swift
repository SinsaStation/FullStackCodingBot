import Foundation
import RxSwift

final class BackUpCenter: BackUpCenterType {
    
    private var firebaseManager: FirebaseManagerType
    private var coreDataManager: CoreDataManagerType
    
    init(firebaseManager: FirebaseManagerType, coreDataManager: CoreDataManagerType) {
        self.firebaseManager = firebaseManager
        self.coreDataManager = coreDataManager
    }
    
    func load(with uuid: String?, _ isFirstLaunched: Bool) -> Observable<NetworkDTO> {
        Observable<NetworkDTO>.create { [unowned self] observer in
            if isFirstLaunched {
                self.coreDataManager.create(with: NetworkDTO.empty())
            }
            
            let localData = self.coreDataManager.read()
            
            guard let uuid = uuid else {
                observer.onNext(localData)
                observer.onCompleted()
                return Disposables.create()
            }
            
            firebaseManager.getFirebaseData(uuid)
                .subscribe { onlineData in
                    let onlineUpdate = onlineData.date
                    let localUpdate = localData.date
                    onlineUpdate > localUpdate ? observer.onNext(onlineData) : observer.onNext(localData)
                    observer.onCompleted()
                } onError: { error in
                    observer.onError(error)
                }.dispose()
            
            return Disposables.create()
        }
    }
}
