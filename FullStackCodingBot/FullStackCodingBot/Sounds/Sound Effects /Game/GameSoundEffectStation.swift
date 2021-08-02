import Foundation
import AVFoundation

struct GameSoundEffectStation {
    private var readySoundPlayer: AVAudioPlayer? = {
        guard let bundlePath = GameSoundEffect.ready.bundlePath,
              let soundPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: bundlePath)) else { return nil }
        return soundPlayer
    }()
    
    private var correctSoundPlayer: AVAudioPlayer? = {
        guard let bundlePath = GameSoundEffect.correct.bundlePath,
              let soundPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: bundlePath)) else { return nil }
        return soundPlayer
    }()
    
    private var wrongSoundPlayer: AVAudioPlayer? = {
        guard let bundlePath = GameSoundEffect.wrong.bundlePath,
              let soundPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: bundlePath)) else { return nil }
        return soundPlayer
    }()
    
    private var feverSoundPlayer: AVAudioPlayer? = {
        guard let bundlePath = GameSoundEffect.fever.bundlePath,
              let soundPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: bundlePath)) else { return nil }
        return soundPlayer
    }()
    
    private var levelUpSoundPlayer: AVAudioPlayer? = {
        guard let bundlePath = GameSoundEffect.levelUp.bundlePath,
              let soundPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: bundlePath)) else { return nil }
        return soundPlayer
    }()
    
    private var gameOverSoundPlayer: AVAudioPlayer? = {
        guard let bundlePath = GameSoundEffect.gameOver.bundlePath,
              let soundPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: bundlePath)) else { return nil }
        return soundPlayer
    }()

    func play(type: GameSoundEffect) {
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
}

enum GameSoundEffect {
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
