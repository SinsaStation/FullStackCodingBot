import UIKit

enum ViewControllerType: CaseIterable {
    case giftVC
    case rankVC
    case itemVC
    case gameVC
    case settingVC
    case howToVC
    case storyVC
}

final class MainButtonMapper {
    private var map: [UIButton: ViewControllerType]
    
    init(from buttons: [UIButton]) {
        self.map = Dictionary(uniqueKeysWithValues: zip(buttons, ViewControllerType.allCases))
    }
    
    subscript(button: UIButton) -> ViewControllerType? {
        return map[button]
    }
}

final class MainButtonController: NSObject {
    
    @IBOutlet var moveToVCButtons: [UIButton]!
    
    private var moveToVCMapper: MainButtonMapper?
    private var buttonTouchedHandler: (ViewControllerType) -> Void
    
    override init() {
        buttonTouchedHandler = { _ in }
    }
    
    func setupButton() {
        self.moveToVCMapper = MainButtonMapper(from: moveToVCButtons)
    }
    
    @IBAction func buttonTouched(sender: UIButton) {
        guard let viewController = moveToVCMapper?[sender] else { return }
        buttonTouchedHandler(viewController)
    }
    
    func bind(action: @escaping (ViewControllerType) -> Void) {
        self.buttonTouchedHandler = action
    }
}
