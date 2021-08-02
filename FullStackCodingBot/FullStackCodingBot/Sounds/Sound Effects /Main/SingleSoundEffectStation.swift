import Foundation
import AVFoundation

struct SingleSoundEffectStation {
    
    private var soundEffectPlayer: AVAudioPlayer?
    
    init(soundEffectType: MainSoundEffect) { 
        self.soundEffectPlayer = AudioPlayerFactory.create(of: soundEffectType, loopEnable: false)
    }
    
    func play() {
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
