import UIKit

enum SwithType: CaseIterable {
    case bgm
    case sound
    case other
}

final class SettingSwitchMapper {
    private var map: [UISwitch: SwithType]
    
    init(from switches: [UISwitch]) {
        self.map = Dictionary(uniqueKeysWithValues: zip(switches, SwithType.allCases))
    }
    
    subscript(settingSwitch: UISwitch) -> SwithType? {
        return map[settingSwitch]
    }
}

final class SettingSwitchController: NSObject {
    
    @IBOutlet var settingSwitches: [UISwitch]!
    
    private var settingSwitchMapper: SettingSwitchMapper?
    private var switchTouchedHandler: (SwithType) -> Void
    
    override init() {
        switchTouchedHandler = { _ in }
    }
    
    func setupSwitch() {
        self.settingSwitchMapper = SettingSwitchMapper(from: settingSwitches)
    }
    
    @IBAction func settingAppInformation(_ sender: UISwitch) {
        guard let settingInfo = settingSwitchMapper?[sender] else { return }
        switchTouchedHandler(settingInfo)
    }
    
    func bind(action: @escaping (SwithType) -> Void) {
        self.switchTouchedHandler = action
    }
}
