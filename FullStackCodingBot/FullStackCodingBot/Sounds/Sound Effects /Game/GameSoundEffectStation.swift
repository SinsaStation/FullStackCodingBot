import Foundation
import AVFoundation

struct GameSoundEffectStation {
    
    private let userDefaults = UserDefaults.standard
    private var readySoundPlayer = AudioPlayerFactory.create(of: GameSoundEffect.ready, mode: .effect)
    private var correctSoundPlayer = AudioPlayerFactory.create(of: GameSoundEffect.correct, mode: .effect)
    private var wrongSoundPlayer = AudioPlayerFactory.create(of: GameSoundEffect.wrong, mode: .effect)
    private var feverSoundPlayer = AudioPlayerFactory.create(of: GameSoundEffect.fever, mode: .effect)
    private var levelUpSoundPlayer = AudioPlayerFactory.create(of: GameSoundEffect.levelUp, mode: .effect)
    private var gameOverSoundPlayer = AudioPlayerFactory.create(of: GameSoundEffect.gameOver, mode: .effect)

    func play(type: GameSoundEffect) {
        guard checkStatus() else { return }
        switch type {
        case .ready:
            readySoundPlayer?.currentTime = 0
            readySoundPlayer?.play()
        case .correct:
            correctSoundPlayer?.currentTime = 0
            correctSoundPlayer?.play()
        case .wrong:
            wrongSoundPlayer?.currentTime = 0
            wrongSoundPlayer?.play()
        case .fever:
            feverSoundPlayer?.currentTime = 0
            feverSoundPlayer?.play()
        case .levelUp:
            levelUpSoundPlayer?.currentTime = 0
            levelUpSoundPlayer?.play()
        case .gameOver:
            gameOverSoundPlayer?.currentTime = 0
            gameOverSoundPlayer?.play()
        }
    }
    
    private func checkStatus() -> Bool {
        let settings = try? userDefaults.getStruct(forKey: IdentifierUD.setting, castTo: SettingInformation.self)
        let soundEffectState = settings?.checkState()[1] ?? true
        return soundEffectState
    }
}

enum GameSoundEffect: BundlePathIncludable {
    case ready
    case correct
    case wrong
    case fever
    case levelUp
    case gameOver
    
    var bundlePath: String? {
        switch self {
        case .ready:
            return Bundle.main.path(forResource: "ready", ofType: "mp3")
        case .correct:
            return Bundle.main.path(forResource: "correct", ofType: "mp3")
        case .wrong:
            return Bundle.main.path(forResource: "wrong", ofType: "wav")
        case .fever:
            return Bundle.main.path(forResource: "fever", ofType: "wav")
        case .levelUp:
            return Bundle.main.path(forResource: "levelup", ofType: "wav")
        case .gameOver:
            return Bundle.main.path(forResource: "gameover", ofType: "wav")
        }
    }
}
