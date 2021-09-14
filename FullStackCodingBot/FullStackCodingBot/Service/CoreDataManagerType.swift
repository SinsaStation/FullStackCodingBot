import Foundation

protocol CoreDataManagerType {
    func create(with initialData: NetworkDTO)
    func read() -> NetworkDTO
}

class FakeCoreDataManager: CoreDataManagerType {
    private var data = NetworkDTO.empty()
    
    func create(with initialData: NetworkDTO) {
        self.data = initialData
    }
    
    func read() -> NetworkDTO {
        return data
    }
}
