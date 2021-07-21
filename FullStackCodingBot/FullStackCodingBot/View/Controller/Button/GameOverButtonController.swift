import UIKit

enum GameOverViewControllerType: CaseIterable {
    case gameVC
    case mainVC
}

final class GameOverButtonMapper {
    private var map: [UIButton: GameOverViewControllerType]
    
    init(from buttons: [UIButton]) {
        self.map = Dictionary(uniqueKeysWithValues: zip(buttons, GameOverViewControllerType.allCases))
    }
    
    subscript(button: UIButton) -> GameOverViewControllerType? {
        return map[button]
    }
}

final class GameOverButtonController: NSObject {
    
    @IBOutlet var moveUnitButtons: [UIButton]!
    
    private var moveUnitMapper: GameOverButtonMapper?
    private var buttonTouchedHandler: (GameOverViewControllerType) -> Void
    
    override init() {
        buttonTouchedHandler = { _ in }
    }
    
    func setupButton() {
        self.moveUnitMapper = GameOverButtonMapper(from: moveUnitButtons)
    }
    
    @IBAction func buttonTouched(sender: UIButton) {
        guard let viewController = moveUnitMapper?[sender] else { return }
        buttonTouchedHandler(viewController)
    }
    
    func bind(action: @escaping (GameOverViewControllerType) -> Void) {
        self.buttonTouchedHandler = action
    }
}
