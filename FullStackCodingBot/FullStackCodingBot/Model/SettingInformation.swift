import Foundation

final class SettingInformation: Codable {
    
    private var bgm: Bool
    private var sound: Bool
    private var vibration: Bool
    
    init(bgm: Bool = true, sound: Bool = true, vibration: Bool = true) {
        self.bgm = bgm
        self.sound = sound
        self.vibration = vibration
    }
    
    func changeState(_ info: SwithType) {
        switch info {
        case .bgm:
            bgm = !bgm
        case .sound:
            sound = !sound
        case .vibration:
            vibration = !vibration
        }
    }
    
    func checkState() -> [Bool] {
        return [bgm, sound, vibration]
    }
    
    static func defaultValues() -> SettingInformation {
        return SettingInformation(bgm: true, sound: true, vibration: true)
    }
}
