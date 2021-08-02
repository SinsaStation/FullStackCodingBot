import Foundation
import AVFoundation

protocol BundlePathIncludable {
    var bundlePath: String? { get }
}

struct AudioPlayerFactory {
    enum Mode {
        case music
        case effect
    }
    
    static func create(of soundType: BundlePathIncludable, mode: Mode) -> AVAudioPlayer? {
        guard let bundlePath = soundType.bundlePath else { return nil }
        let url = URL(fileURLWithPath: bundlePath)
        let audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.numberOfLoops = mode == .music ? .max : 0
        return audioPlayer
    }
}
