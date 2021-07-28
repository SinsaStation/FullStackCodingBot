import UIKit

enum Direction: CaseIterable {
    case left
    case right
}

final class GameButtonMapper {
    private var map: [UIButton: Direction]
    
    init(from buttons: [UIButton]) {
        self.map = Dictionary(uniqueKeysWithValues: zip(buttons, Direction.allCases))
    }
    
    subscript(button: UIButton) -> Direction? {
        return map[button]
    }
}

final class GameButtonController: NSObject {
    
    @IBOutlet var moveUnitButtons: [UIButton]!
    
    private var moveUnitMapper: GameButtonMapper?
    private var buttonTouchedHandler: (Direction) -> Void
    
    override init() {
        buttonTouchedHandler = { _ in }
    }
    
    func setupButton() {
        self.moveUnitMapper = GameButtonMapper(from: moveUnitButtons)
    }
    
    @IBAction func buttonTouched(sender: UIButton) {
        guard let viewController = moveUnitMapper?[sender] else { return }
        buttonTouchedHandler(viewController)
    }
    
    func bind(action: @escaping (Direction) -> Void) {
        self.buttonTouchedHandler = action
    }
    
    func changeButtonStatus(to enable: Bool) {
        DispatchQueue.main.async {
            self.moveUnitButtons.forEach { button in
                button.isEnabled = enable
            }
        }
    }
}
