import Foundation

enum DataParsingError: Error {
    case cannotTransformToString
    case cannotTransformToStruct
}

enum CoreDataError: Error {
    case cannotFetchData
    case cannotSaveData
}
