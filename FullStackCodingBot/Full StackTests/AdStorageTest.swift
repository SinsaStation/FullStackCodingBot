import XCTest

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
        let isUpdated = adStorage.setNewRewardsIfPossible(with: yesterdayInformation)
        XCTAssertEqual(isUpdated, true)
    }
    
    func test_ShouldNotUpdateRewards() throws {
        let currentInformation = AdsInformation(ads: [], lastUpdated: now, gift: nil)
        let isUpdated = adStorage.setNewRewardsIfPossible(with: currentInformation)
        XCTAssertEqual(isUpdated, false)
    }
}
