import Foundation
import AVFoundation

protocol BundlePathIncludable {
    var bundlePath: String? { get }
}

struct AudioPlayerFactory {
    static func create(of soundType: BundlePathIncludable, loopEnable: Bool) -> AVAudioPlayer? {
        guard let bundlePath = soundType.bundlePath else { return nil }
        let url = URL(fileURLWithPath: bundlePath)
        let audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.numberOfLoops = loopEnable ? .max : 0
        return audioPlayer
    }
}
