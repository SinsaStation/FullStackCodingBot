import Foundation
import Firebase

struct Units: Decodable {
    let units: String
}

final class FirebaseDataManager {
    
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
    
    static func transformToString(_ uuid: String) -> String? {
        let data = Unit.initialValues()
        
        do {
            let encodedData = try JSONEncoder().encode(data)
            let storedData = String(data: encodedData, encoding: .utf8)
            return storedData
        } catch let error {
            print(error)
        }
        
        return ""
    }
}
