import Foundation

struct Unit: Equatable {
    let uuid: Int
    let image: String
    let level: Int
    
    init(info: UnitInfo, level: Int) {
        uuid = info.detail.id
        image = info.detail.image
        self.level = level
    }
}

enum UnitInfo {
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
            return ("c", 5)
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
