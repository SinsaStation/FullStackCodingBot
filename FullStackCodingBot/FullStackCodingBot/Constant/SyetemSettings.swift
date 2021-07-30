import Foundation

enum GameSetting {
    static let count = 7
    static let maxUnitCount = 8
    static let readyTime: Double = 1.3
    static let startingTime = 60
    static let feverGaugeMax = 20
    static let feverTime = 10
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
    static let shopReset = "Coffee refills at 12AM!"
    
    static func reward(amount: Int) -> String {
        return "Got \(amount) Coins!"
    }
    
    static let levelUp = "Tab button to level up!"
    
    static func levelUpSuccessed(unitType: String, to level: Int) -> String {
        return "Yay! \(unitType) did level up to \(level)!"
    }
    
    static func levelUpFailed(coinNeeded: Int) -> String {
        return "You need \(coinNeeded) to level up!"
    }
}
