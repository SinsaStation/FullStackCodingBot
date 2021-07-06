import Foundation

struct Unit {
    let image: UnitImage
    let level: Int
    let count: Int
}

enum UnitImage {
    case swift
    case kotlin
    case java
    case cPlusPlus
    
    var name: String {
        switch self {
        case .swift:
            return "swift"
        case .kotlin:
            return "kotlin"
        case .java:
            return "java"
        case .cPlusPlus:
            return "cpp"
        }
    }
}
