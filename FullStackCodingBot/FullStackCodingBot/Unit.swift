//
//  Unit.swift
//  FullStackCodingBot
//
//  Created by Song on 2021/07/05.
//

import Foundation

struct Unit {
    let image: UnitImage
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
