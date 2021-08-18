import Foundation

struct Unit: Codable {
    let uuid: Int
    let image: String
    let name: String
    var level: Int
    
    init(info: UnitInfo, level: Int) {
        uuid = info.detail.id
        image = info.detail.image
        name = info.rawValue
        self.level = level
    }
    
    init(original: Unit, level: Int) {
        self = original
        self.level = level
    }

    func score() -> Int {
        return level + 10
    }
    
    func randomCode() -> String {
        return UnitInfo.randomCode(for: self.uuid)
    }

    static func initialValues() -> [Unit] {
        let allUnits = UnitInfo.allCases.map { Unit(info: $0, level: 1) }
        return allUnits
    }
}

extension Unit: Equatable {
    static func == (lhs: Unit, rhs: Unit) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
