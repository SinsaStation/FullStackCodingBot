import Foundation

enum DataParsingError: Error {
    case cannotTransformToString
    case cannotTransformToStruct
}

enum CoreDataError: Error {
    case cannotFetchData
    case cannotSaveData
}

enum StructSavableError: Error {
    case unableToDecode
    case unableToEncode
    case noValue
}

enum TransitionError: Error {
    case unknown
}
