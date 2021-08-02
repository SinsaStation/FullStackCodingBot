import Foundation
import AVFoundation

final class MusicStation {

    static let shared = MusicStation()
    
    private var musicEnabled = true
    private var musicPlayer: AVAudioPlayer?
    
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

    func changeEnableState(to isMusicOn: Bool) {
        self.musicEnabled = isMusicOn
    }
    
    func play(type: Music) {
        guard musicEnabled else { return }
        setNewPlayer(of: type)
        musicPlayer?.play()
    }
    
    private func setNewPlayer(of musicType: Music) {
        guard let bundlePath = musicType.bundlePath else { return }
        guard let newMusicPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: bundlePath)) else { return }
        newMusicPlayer.numberOfLoops = .max
        self.musicPlayer = newMusicPlayer
    }
    
    func stop() {
        musicPlayer?.stop()
    }
}
