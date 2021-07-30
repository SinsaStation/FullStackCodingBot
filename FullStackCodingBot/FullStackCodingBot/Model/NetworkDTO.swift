import Foundation

struct UnitInformation: Decodable {
    let info: [String: String]
    
    enum Codingkeys: String, CodingKey {
        case info
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Codingkeys.self)
        let decodedInfo = try container.decode([String: String].self, forKey: .info)
        info = decodedInfo
    }
}

struct AdsInformation: Codable {
    let ads: [Bool]
    let lastUpdated: Date
    let gift: Int?
    
    static func empty() -> AdsInformation {
        return AdsInformation(ads: [], lastUpdated: Date(timeIntervalSince1970: 0), gift: nil)
    }
}

struct NetworkDTO: Codable {
    let units: [Unit]
    let money: Int
    let score: Int
    let ads: AdsInformation
    
    static func empty() -> NetworkDTO {
        return NetworkDTO(units: [], money: 0, score: 0, ads: AdsInformation.empty())
    }
}
