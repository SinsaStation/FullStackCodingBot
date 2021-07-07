import UIKit

enum ViewControllerType: CaseIterable {
    case giftVC
    case rankVC
    case itemVC
    case gameVC
}

final class ButtonMapper {
    private var map: [UIButton: ViewControllerType]
    
    init(from buttons: [UIButton]) {
        self.map = Dictionary(uniqueKeysWithValues: zip(buttons, ViewControllerType.allCases))
    }
    
    subscript(button: UIButton) -> ViewControllerType? {
        return map[button]
    }
}

final class ButtonController: NSObject {
    
    @IBOutlet var moveToVCButtons: [UIButton]!
    
    private var moveToVCMapper: ButtonMapper?
    private var buttonTouchedHandler: (ViewControllerType) -> ()
    
    override init() {
        buttonTouchedHandler = { _ in }
    }
    
    func setupButton() {
        self.moveToVCMapper = ButtonMapper(from: moveToVCButtons)
    }
    
    @IBAction func buttonTouched(sender: UIButton)  {
        guard let vc = moveToVCMapper?[sender] else { return }
        buttonTouchedHandler(vc)
    }
    
    func bind(action: @escaping (ViewControllerType) -> ()) {
        self.buttonTouchedHandler = action
    }
}
