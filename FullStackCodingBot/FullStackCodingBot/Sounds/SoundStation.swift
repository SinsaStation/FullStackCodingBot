import Foundation
import AVFoundation

class SoundStation {

    static let shared = SoundStation(musicEnabled: true, effectEnabled: true)
    
    private var musicEnabled: Bool
    private var musicPlayer: AVAudioPlayer?
    private var effectEnabled: Bool
    private var effectPlayer: AVAudioPlayer?
    
    init(musicEnabled: Bool, effectEnabled: Bool) {
        self.musicEnabled = musicEnabled
        self.effectEnabled = effectEnabled
    }
    
    enum Music {
        case main
        case game
        
        var bundlePath: String? {
            switch self {
            case .main:
                return Bundle.main.path(forResource: "main", ofType: "mp3")
            case .game:
                return Bundle.main.path(forResource: "game", ofType: "wav")
            }
        }
    }

    enum Effect {
        case fever
        case gameOver
        
    }
    
    func musicPlay(type: Music) {
        guard musicEnabled else { return }
        setNewMusicPlayer(of: type)
        musicPlayer?.play()
    }
    
    private func setNewMusicPlayer(of musicType: Music) {
        guard let bundlePath = musicType.bundlePath else { return }
        
        do {
            let newMusicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: bundlePath))
            newMusicPlayer.numberOfLoops = .max
            
            // 앱 델리게이트 설정 필요
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
            try AVAudioSession.sharedInstance().setActive(true)
            self.musicPlayer = newMusicPlayer
        } catch {
            print(error)
        }
    }
    
    func musicStop() {
        musicPlayer?.stop()
    }
    
    func effectPlay(type: Effect) {
        guard effectEnabled else { return }
        
    }
}
