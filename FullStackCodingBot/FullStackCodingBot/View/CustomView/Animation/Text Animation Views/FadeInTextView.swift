import UIKit

final class FadeInTextView: TextPresentView {

    private let duration: Double = 0.8
    private let opacityKey = #keyPath(CALayer.opacity)
    
    override func show(text fullText: String, color: UIColor = Defaults.textColor) {
        super.show(text: fullText, color: color)
        textLayer.add(newFadeInAnimation(for: duration), forKey: opacityKey)
    }

    private func newFadeInAnimation(for duration: Double) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: opacityKey)
        animation.duration = duration
        animation.values = [0.0, 1.0]
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeOut)
        return animation
    }
}
