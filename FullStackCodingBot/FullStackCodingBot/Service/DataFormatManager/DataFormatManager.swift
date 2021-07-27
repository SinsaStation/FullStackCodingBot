import Foundation
import Firebase

struct Units: Decodable {
    let units: String
}

final class DataFormatManager {
    
    static func transformToStruct(_ data: [String: Any]) -> [Unit] {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            let units = try JSONDecoder().decode(Units.self, from: jsonData)
            let unit = try JSONDecoder().decode([Unit].self, from: Data(units.units.utf8))
            return unit
        } catch let error {
            print(error)
        }
        
        return []
    }
    
    static func transformToString(_ data: [Unit]) -> String? {
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
