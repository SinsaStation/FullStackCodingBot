import Foundation

protocol GameStorageType {
    func update(with data: NetworkDTO)
}

class FakeGameStorage: GameStorageType {
    func update(with data: NetworkDTO) {
        /*
         ViewModel에서 다음과 같은 코드로 업데이트를 했었다
         storage.update(units: info.units)
         storage.raiseMoney(by: info.money)
         storage.updateHighScore(new: info.score)
         */
    }
}
