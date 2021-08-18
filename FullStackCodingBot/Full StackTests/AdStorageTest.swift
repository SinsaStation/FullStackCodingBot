import XCTest
import RxSwift

class AdStorageTest: XCTestCase {
    
    private let now = Date()
    private var adStorage: AdStorageType!

    override func setUpWithError() throws {
        let emptyInformation = AdsInformation.empty()
        adStorage = MockAdStorage(with: emptyInformation)
    }

    func test_ShouldUpdateRewards() throws {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        let yesterdayInformation = AdsInformation(ads: [], lastUpdated: yesterday, gift: nil)
        
        adStorage.setNewRewardsIfPossible(with: yesterdayInformation)
            .subscribe(onNext: { result in
                XCTAssertEqual(result, true)
            }).disposed(by: rx.disposeBag)
    }
    
    func test_ShouldNotUpdateRewards() throws {
        let currentInformation = AdsInformation(ads: [], lastUpdated: now, gift: nil)
        adStorage.setNewRewardsIfPossible(with: currentInformation)
            .subscribe(onNext: { result in
                XCTAssertEqual(result, false)
            }).disposed(by: rx.disposeBag)
    }
}
