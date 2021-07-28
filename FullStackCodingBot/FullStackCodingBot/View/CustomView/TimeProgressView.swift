import UIKit

final class TimeProgressView: UIProgressView {
    
    private let normalColor = UIColor(named: "digitalgreen") ?? UIColor.green
    private let wrongColor = UIColor(named: "red") ?? UIColor.red
    
    func playWrongMode() {
        self.progressTintColor = self.wrongColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.progressTintColor = self.normalColor
        }
    }
}
