import Foundation
import RxSwift

final class Storage {
    
    private var gameStorage: GameStorageType
    private var adStorage: AdStorageType
    private var backUpCenter: BackUpCenterType

    init(gameStorage: GameStorageType, adStorage: AdStorageType, backUpCenter: BackUpCenterType) {
        self.gameStorage = gameStorage
        self.adStorage = adStorage
        self.backUpCenter = backUpCenter
    }
    
    func fill(using uuid: String?, isFirstLaunched: Bool) -> Observable<Bool> {
        Observable.create { [weak self] observer in
            self?.backUpCenter.load(with: uuid, isFirstLaunched)
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(onNext: { data in
                    self?.gameStorage.update(with: data)
                    self?.adStorage.setNewRewardsIfPossible(with: data.ads)
                }, onError: { _ in
                    observer.onNext(false)
                }, onCompleted: {
                    observer.onNext(true)
                }).dispose()
            return Disposables.create()
        }
    }
}
