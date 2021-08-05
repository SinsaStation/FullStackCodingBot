import Foundation

struct NetworkDTO: Codable {
    let units: [Unit]
    let money: Int
    let score: Int
    let ads: AdsInformation
    
    static func empty() -> NetworkDTO {
        return NetworkDTO(units: [], money: 0, score: 0, ads: AdsInformation.empty())
    }
}
