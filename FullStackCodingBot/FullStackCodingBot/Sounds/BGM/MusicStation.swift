import Foundation
import AVFoundation

struct MusicStation {
    
    static let shared = MusicStation()
    private var mainMusicPlayer = AudioPlayerFactory.create(of: Music.main, mode: .music)
    private var gameMusicPlayer = AudioPlayerFactory.create(of: Music.game, mode: .music)

    func play(type: Music) {
        guard checkStatus() else { return }
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
    
    private func checkStatus() -> Bool {
        let settings = try? UserDefaults.standard.getStruct(forKey: IdentifierUD.setting, castTo: SettingInformation.self)
        let soundEffectState = settings?.checkState()[0] ?? true
        return soundEffectState
    }
    
    func stop() {
        mainMusicPlayer?.stop()
        gameMusicPlayer?.stop()
    }
    
    func toggle(musicToPlay: Music = .main) {
        guard let mainMusicPlayer = mainMusicPlayer,
              let gameMusicPlayer = gameMusicPlayer else { return }
        let isPlaying = mainMusicPlayer.isPlaying || gameMusicPlayer.isPlaying
        isPlaying ? stop() : play(type: musicToPlay)
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
