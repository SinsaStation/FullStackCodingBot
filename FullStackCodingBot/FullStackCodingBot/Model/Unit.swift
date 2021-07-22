import Foundation

struct Unit: Equatable {
    let uuid: Int
    let image: String
    var level: Int
    
    init(info: UnitInfo, level: Int) {
        uuid = info.detail.id
        image = info.detail.image
        self.level = level
    }
    
    init(original: Unit, level: Int) {
        self = original
        self.level = level
    }

    func score() -> Int {
        return level + 10
    }
    
    static func == (lhs: Unit, rhs: Unit) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    static func initialValues() -> NSString {
        let units = [
            Unit(info: .cPlusPlus, level: 1),
            Unit(info: .java, level: 1),
            Unit(info: .swift, level: 1),
            Unit(info: .kotlin, level: 1),
            Unit(info: .python, level: 1),
            Unit(info: .cSharp, level: 2),
            Unit(info: .php, level: 1),
            Unit(info: .javaScript, level: 1),
            Unit(info: .ruby, level: 1),
            Unit(info: .theC, level: 1)
        ]
        return "\(units)" as NSString
    }
}

enum UnitInfo: CaseIterable {
    case swift
    case kotlin
    case java
    case cPlusPlus
    case python
    case theC
    case php
    case javaScript
    case cSharp
    case ruby
    
    var detail: (image: String, id: Int) {
        switch self {
        case .swift:
            return ("swift", 0)
        case .kotlin:
            return ("kotlin", 1)
        case .java:
            return ("java", 2)
        case .cPlusPlus:
            return ("cpp", 3)
        case .python:
            return ("python", 4)
        case .theC:
            return ("theC", 5)
        case .php:
            return ("php", 6)
        case .javaScript:
            return ("javaScript", 7)
        case .cSharp:
            return ("cSharp", 8)
        case .ruby:
            return ("ruby", 9)
        }
    }
}
