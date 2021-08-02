import Foundation
import AVFoundation

final class MusicStation {

    static let shared = MusicStation()
    
    private var musicEnabled = true
    
    private lazy var mainMusicPlayer: AVAudioPlayer? = {
        guard let bundlePath = Music.main.bundlePath,
              let musicPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: bundlePath)) else { return nil }
        musicPlayer.numberOfLoops = .max
        return musicPlayer
    }()
    
    private lazy var gameMusicPlayer: AVAudioPlayer? = {
        guard let bundlePath = Music.game.bundlePath,
              let musicPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: bundlePath)) else { return nil }
        musicPlayer.numberOfLoops = .max
        return musicPlayer
    }()
    
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
        
        switch type {
        case .main:
            mainMusicPlayer?.play()
        case .game:
            gameMusicPlayer?.play()
        }
    }
    
    func stop() {
        mainMusicPlayer?.stop()
        gameMusicPlayer?.stop()
    }
}
