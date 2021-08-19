import Foundation
import Firebase

protocol StructSavable {
    func setStruct<Object: Encodable>(_ object: Object, forKey: String) throws
    func getStruct<Object: Decodable>(forKey: String, castTo type: Object.Type) throws -> Object
}

extension UserDefaults: StructSavable {
    func setStruct<Object: Encodable>(_ object: Object, forKey: String) throws {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            Firebase.Analytics.logEvent("SetErrorUD", parameters: nil)
            throw StructSavableError.unableToEncode
        }
    }
    
    func getStruct<Object: Decodable>(forKey: String, castTo type: Object.Type) throws -> Object {
        guard let data = data(forKey: forKey) else { throw StructSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            Firebase.Analytics.logEvent("GetErrorUD", parameters: nil)
            throw StructSavableError.unableToDecode
        }
    }
    
    static func checkStatus(of optionType: SwithType) -> Bool {
        guard let targetIndex = SwithType.allCases.firstIndex(of: optionType) else { return false }
        let settings = try? UserDefaults.standard.getStruct(forKey: IdentifierUD.setting, castTo: SettingInformation.self)
        let targetStatus = settings?.checkState()[targetIndex] ?? true
        return targetStatus
    }
}
