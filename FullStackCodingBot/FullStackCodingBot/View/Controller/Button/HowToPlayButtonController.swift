import UIKit

enum DirectionType: CaseIterable {
    case left
    case right
}

final class DirectionButtonMapper {
    private var map: [UIButton: DirectionType]
    
    init(from buttons: [UIButton]) {
        self.map = Dictionary(uniqueKeysWithValues: zip(buttons, DirectionType.allCases))
    }
    
    subscript(button: UIButton) -> DirectionType? {
        return map[button]
    }
}

final class DirectionButtonController: NSObject {
    
    @IBOutlet var directionButtons: [UIButton]!
    
    private var buttonMapper: DirectionButtonMapper?
    private var buttonTouchedHandler: (DirectionType) -> Void
    
    override init() {
        buttonTouchedHandler = { _ in }
    }
    
    func setupButton() {
        self.buttonMapper = DirectionButtonMapper(from: directionButtons)
    }
    
    @IBAction func buttonTouched(_ sender: UIButton) {
        guard let direction = buttonMapper?[sender] else { return }
        buttonTouchedHandler(direction)
    }
    
    func bind(action: @escaping (DirectionType) -> Void) {
        self.buttonTouchedHandler = action
    }
}
