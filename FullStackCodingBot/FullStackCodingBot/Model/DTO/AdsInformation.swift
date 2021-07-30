import Foundation

struct AdsInformation: Codable {
    let ads: [Bool]
    let lastUpdated: Date
    let gift: Int?
    
    static func empty() -> AdsInformation {
        return AdsInformation(ads: [], lastUpdated: Date(timeIntervalSince1970: 0), gift: nil)
    }
}
