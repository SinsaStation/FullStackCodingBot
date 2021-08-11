import Foundation
import RxSwift
import Firebase

final class DataFormatManager {
    
    static func transformToLocalData(_ data: [String: Any]) throws -> NetworkDTO {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            let info = try JSONDecoder().decode(UnitInformation.self, from: jsonData)
            let units = try JSONDecoder().decode([Unit].self, from: Data(info.info["units"]!.utf8))
            let money = try JSONDecoder().decode(Int.self, from: Data(info.info["money"]!.utf8))
            let score = try JSONDecoder().decode(Int.self, from: Data(info.info["score"]!.utf8))
            let ads = try JSONDecoder().decode(AdsInformation.self, from: Data(info.info["ads"]!.utf8))
            let result = NetworkDTO(units: units, money: money, score: score, ads: ads)
            return result
        } catch  {
            throw DataParsingError.cannotTransformToStruct
        }
    }
    
    static func transformToString<T: Encodable>(_ data: T) throws -> String? {
        do {
            let encodedData = try JSONEncoder().encode(data)
            let storedData = String(data: encodedData, encoding: .utf8)
            return storedData
        } catch {
            throw DataParsingError.cannotTransformToString
        }
    }
    
    static func transformToUnit(_ info: ItemInformation) -> Unit {
        let uuid = Int(info.uuid)
        let level = Int(info.level)
        let unitInfo = UnitInfo.allCases[uuid]
        return Unit(info: unitInfo, level: level)
    }
    
    static func transformToMoney(_ info: MoneyInformation) -> Int {
        return Int(info.myMoney)
    }
}
