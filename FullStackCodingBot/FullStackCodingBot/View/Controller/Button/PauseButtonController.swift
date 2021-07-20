import UIKit

enum PauseActionType: CaseIterable {
    case resume
    case restart
    case toMain
}

final class PauseButtonMapper {
    private var map: [UIButton: PauseActionType]
    
    init(from buttons: [UIButton]) {
        self.map = Dictionary(uniqueKeysWithValues: zip(buttons, PauseActionType.allCases))
    }
    
    subscript(button: UIButton) -> PauseActionType? {
        return map[button]
    }
}

final class PauseButtonController: NSObject {
    
    @IBOutlet var moveUnitButtons: [UIButton]!
    
    private var moveUnitMapper: PauseButtonMapper?
    private var buttonTouchedHandler: (PauseActionType) -> Void
    
    override init() {
        buttonTouchedHandler = { _ in }
    }
    
    func setupButton() {
        self.moveUnitMapper = PauseButtonMapper(from: moveUnitButtons)
    }
    
    @IBAction func buttonTouched(sender: UIButton) {
        guard let viewController = moveUnitMapper?[sender] else { return }
        buttonTouchedHandler(viewController)
    }
    
    func bind(action: @escaping (PauseActionType) -> Void) {
        self.buttonTouchedHandler = action
    }
}
