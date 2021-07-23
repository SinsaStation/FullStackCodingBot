import Foundation

enum GameSetting {
    static let count = 7
    static let maxUnitCount = 8
    static let startingTime: Int64 = 60
    static let wrongTime = 10
    static let startingCount = 2
    static let timeUnit = 1
}

enum ShopSetting {
    static let freeReward = 1
    static let adForADay = 5
    
    static func reward() -> Int {
        return 500 + Int.random(in: 0...1000)
    }
}

enum Text {
    static let title = "Full Stack \nCoding Master"
    static let shopReset = "Shop resets at 12:00AM!"
    
    static func reward(amount: Int) -> String {
        return "Got \(amount) Coins!"
    }
}
