import Foundation
import AVFoundation

final class SingleSoundEffectStation {
    
    private var soundEffectPlayer: AVAudioPlayer?
    
    init(soundEffectType: MainSoundEffect) {
        let bundlePath = soundEffectType.bundlePath ?? ""
        let player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: bundlePath))
        player?.numberOfLoops = 0
        self.soundEffectPlayer = player
    }
    
    func play() {
        soundEffectPlayer?.currentTime = 0
        soundEffectPlayer?.play()
    }
}

enum MainSoundEffect {
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
