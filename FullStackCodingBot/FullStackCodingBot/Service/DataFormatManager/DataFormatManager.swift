import Foundation
import Firebase

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

final class DataFormatManager {
    
    static func transformToStruct(_ data: [String: Any]) -> ([Unit], Int) {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            let info = try JSONDecoder().decode(UnitInformation.self, from: jsonData)
            let money = try JSONDecoder().decode(Int.self, from: Data(info.info["money"]!.utf8))
            let units = try JSONDecoder().decode([Unit].self, from: Data(info.info["units"]!.utf8))
            return (units, money)
        } catch let error {
            print(error)
        }
        
        return ([], 0)
    }
    
    static func transformToString<T: Encodable>(_ data: T) -> String? {
        do {
            let encodedData = try JSONEncoder().encode(data)
            let storedData = String(data: encodedData, encoding: .utf8)
            return storedData
        } catch let error {
            print(error)
        }
        
        return ""
    }
    
    static func transformToUnit(_ info: ItemInformation) -> Unit {
        let uuid = Int(info.uuid)
        let image = info.image ?? ""
        let level = Int(info.level)
        return Unit(uuid: uuid, image: image, level: level)
    }
    
    static func transformToMoney(_ info: MoneyInformation) -> Int {
        return Int(info.myMoney)
    }
}
