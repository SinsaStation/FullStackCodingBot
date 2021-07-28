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

struct NetworkDTO: Codable {
    let units: [Unit]
    let money: Int
    let score: Int
    
    static func empty() -> NetworkDTO {
        return NetworkDTO(units: [], money: 0, score: 0)
    }
}
