import Foundation
import RxSwift
import GoogleMobileAds

final class AdStorage: AdStorageType {

    private var lastUpdate: Date
    private var giftStatus: ShopItem
    private var ads: [ShopItem]
    private lazy var itemStorage = BehaviorSubject(value: items())
    private let disposeBag = DisposeBag()
    
    init(lastUpdate: Date = Date(timeIntervalSince1970: 0),
         giftStatus: ShopItem = .taken,
         ads: [ShopItem] = Array(repeating: .taken, count: ShopSetting.adForADay)) {
        self.lastUpdate = lastUpdate
        self.giftStatus = giftStatus
        self.ads = ads
    }
    
    func setNewRewardsIfPossible(with newInfo: AdsInformation?) -> Observable<Bool> {
        Observable.create { [unowned self] observer in
            let currentInfo = newInfo ?? self.currentInformation()
            self.lastUpdate = currentInfo.lastUpdated
            
            if !isUpdatable() {
                setRewards(from: currentInfo)
                    .subscribe(onError: { error in
                        observer.onError(error)
                    }).disposed(by: disposeBag)
                observer.onNext(false)
                observer.onCompleted()
                return Disposables.create()
            }
            
            setAds().subscribe(onError: { error in
                    observer.onError(error)
                }).disposed(by: disposeBag)
            setGifts()
            
            observer.onNext(true)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    private func isUpdatable() -> Bool {
        let today = Date()
        let isUpdated = Calendar.current.isDate(today, inSameDayAs: lastUpdate)
        lastUpdate = today
        return !isUpdated
    }
    
    private func setRewards(from currentInfo: AdsInformation) -> Observable<Void> {
        Observable.create { [unowned self] observer in
            let currentAdStates = currentInfo.ads
            self.setAds(with: currentAdStates)
                .subscribe(onError: { error in
                    observer.onError(error)
                }).disposed(by: disposeBag)
            let currentGiftState: ShopItem = currentInfo.gift != nil ? .gift : .taken
            self.setGifts(with: currentGiftState)
            return Disposables.create()
        }
    }
    
    private func setAds(with adStates: [Bool] = Array(repeating: true, count: ShopSetting.adForADay)) -> Observable<Void> {
        Observable.create { [unowned self] observer in
            adStates.enumerated().forEach { index, isAvailable in
                if isAvailable {
                    self.downloadAd(to: index)
                        .subscribe(onError: { error in
                            observer.onError(error)
                        }).disposed(by: disposeBag)
                    self.ads[index] = ShopItem.loading
                } else {
                    self.ads[index] = ShopItem.taken
                }
            }
            publishCurrentItems()
            return Disposables.create()
        }
    }
    
    private func downloadAd(to index: Int) -> Observable<Void> {
        Observable.create { observer in
            let request = GADRequest()
            GADRewardedAd.load(withAdUnitID: IdentiferAD.test, request: request) { [unowned self] ads, error in
                
                if let error = error {
                    observer.onError(error)
                }
                
                if let newAd = ads {
                    self.ads[index] = ShopItem.adMob(newAd)
                    self.publishCurrentItems()
                }
            }
            return Disposables.create()
        }
    }
    
    private func publishCurrentItems() {
        itemStorage.onNext(items())
    }
    
    private func setGifts(with giftState: ShopItem = .gift) {
        self.giftStatus = giftState
        publishCurrentItems()
    }
    
    private func items() -> [ShopItem] {
        return ads + [giftStatus]
    }
    
    func availableItems() -> Observable<[ShopItem]> {
        return itemStorage
    }
    
    func adDidFinished(_ finishedAd: GADRewardedAd) {
        ads.enumerated().forEach { index, targetAd in
            switch targetAd {
            case .adMob(let targetAd):
                if targetAd == finishedAd {
                    ads[index] = .taken
                }
            default:
                return
            }
        }
        publishCurrentItems()
    }
    
    func giftTaken() {
        giftStatus = .taken
        publishCurrentItems()
    }
    
    func currentInformation() -> AdsInformation {
        let ads = adsToStatus()
        let gift = giftToStatus()
        let result = AdsInformation(ads: ads, lastUpdated: lastUpdate, gift: gift)
        return result
    }
        
    private func adsToStatus() -> [Bool] {
        return ads.map { status in
            switch status {
            case .taken:
                return false
            default:
                return true
            }
        }
    }
    
    private func giftToStatus() -> Int? {
        switch giftStatus {
        case .gift:
            return 0
        default:
            return nil
        }
    }
}
