import Foundation

enum GameSetting {
    static let count = 7
    static let maxUnitCount = 8
    static let startingCount = 2
    static let feverGaugeMax = 20
}

enum TimeSetting {
    static let readyTime: Double = 1.3
    static let startingTime: Double = 60
    static let feverTime: Double = 10
    static let wrongTime: Double = 10
    static let timeUnit: Double = 0.1
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
    static let giftTaken = "Coffee is already taken"
    static let giftLoading = "Making coffee..."
    static let matchFailed = "Bug Detected!!! Bug Detected!!!\nBug Detected!!! Bug Detected!!!\nBug Detected!!! Bug Detected!!!"
    
    static func reward(amount: Int) -> String {
        return "Got \(amount) energy!"
    }
    
    static let levelUp = "Tab button to level up!"
    
    static func levelUpSuccessed(unitType: String, to level: Int) -> String {
        return "\(unitType) did level up to \(level)!"
    }
    
    static func levelUpFailed(coinNeeded: Int) -> String {
        return "You need \(coinNeeded) to level up!"
    }
}
