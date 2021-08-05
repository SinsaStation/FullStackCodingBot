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
