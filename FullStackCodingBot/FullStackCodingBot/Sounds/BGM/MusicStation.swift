import Foundation
import AVFoundation

struct MusicStation {

    static let shared = MusicStation()
    private var mainMusicPlayer = AudioPlayerFactory.create(of: Music.main, mode: .music)
    private var gameMusicPlayer = AudioPlayerFactory.create(of: Music.game, mode: .music)

    func play(type: Music) {
        switch type {
        case .main:
            mainMusicPlayer?.currentTime = 0
            mainMusicPlayer?.play()
            gameMusicPlayer?.stop()
        case .game:
            gameMusicPlayer?.currentTime = 0
            gameMusicPlayer?.play()
            mainMusicPlayer?.stop()
        }
    }
    
    func stop() {
        mainMusicPlayer?.stop()
        gameMusicPlayer?.stop()
    }
}

enum Music: BundlePathIncludable {
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
