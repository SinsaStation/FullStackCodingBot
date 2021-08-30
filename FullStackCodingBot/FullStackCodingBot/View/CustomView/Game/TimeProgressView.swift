import UIKit

final class TimeProgressView: UIProgressView {
    func playWrongMode() {
        self.progressTintColor = UIColor.wrong
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.progressTintColor = UIColor.match
        }
    }
}
