import Foundation
import AVFoundation

struct SingleSoundEffectStation {
    
    private let userDefaults = UserDefaults.standard
    private var soundEffectPlayer: AVAudioPlayer?
    
    init(soundEffectType: MainSoundEffect) {
        self.soundEffectPlayer = AudioPlayerFactory.create(of: soundEffectType, mode: .effect)
    }
    
    func play() {
        guard UserDefaults.checkStatus(of: .sound) else { return }
        soundEffectPlayer?.currentTime = 0
        soundEffectPlayer?.play()
    }
}

enum MainSoundEffect: BundlePathIncludable {
    case reward
    case upgrade
    
    var bundlePath: String? {
        switch self {
        case .reward:
            return Bundle.main.path(forResource: "reward", ofType: "wav")
        case .upgrade:
            return Bundle.main.path(forResource: "upgrade", ofType: "wav")
        }
    }
}
