import Foundation

struct NetworkDTO: Codable {
    let units: [Unit]
    let money: Int
    let score: Int
    let ads: AdsInformation
    let date: Date
    
    static func empty() -> NetworkDTO {
        return NetworkDTO(units: [], money: 0, score: 0, ads: AdsInformation.empty(), date: Date.init(timeIntervalSince1970: 0))
    }
}
