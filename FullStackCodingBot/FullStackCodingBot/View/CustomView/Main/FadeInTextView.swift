import UIKit

final class FadeInTextView: UIView {

    private let opacityKey = #keyPath(CALayer.opacity)
    private let textColor = UIColor(named: "digitalgreen") ?? UIColor.green
    private let fontSize: CGFloat = 16
    private lazy var font = UIFont(name: Font.joystix, size: fontSize) ?? UIFont()
    private lazy var textLayer: CATextLayer = {
        let textLayer = CATextLayer()
        textLayer.font = self.font
        textLayer.fontSize = self.fontSize
        textLayer.alignmentMode = .center
        textLayer.frame = CGRect(origin: .zero, size: layer.bounds.size)
        textLayer.foregroundColor = textColor.cgColor
        layer.addSublayer(textLayer)
        return textLayer
    }()
    
    func show(text fullText: String, duration: Double=0.8) {
        setTextLayer(with: fullText)
        textLayer.add(newFadeInAnimation(for: duration), forKey: opacityKey)
    }
    
    private func setTextLayer(with text: String) {
        textLayer.string = text
        textLayer.fontSize = newFontSize(for: text)
        adjustTextLayerFrameToCenter(for: text)
    }
    
    private func newFadeInAnimation(for duration: Double) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: opacityKey)
        animation.duration = duration
        animation.values = [0.0, 1.0]
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeOut)
        return animation
    }
    
    private func newFontSize(for text: String) -> CGFloat {
        let letterCountsPerLine = text.components(separatedBy: "\n").map { $0.count }
        let maxLetterCount = letterCountsPerLine.max() ?? 15
        let newFontSize = textLayer.bounds.width / CGFloat(maxLetterCount)
        return newFontSize
    }
    
    private func adjustTextLayerFrameToCenter(for fullText: String) {
        let lineCount = fullText.components(separatedBy: "\n").count
        let fontHeight = font.capHeight
        let totalTextHeight = fontHeight * CGFloat(lineCount)
        let yPosition = (layer.bounds.size.height - totalTextHeight * 1.5) / 2
        let newOrigin = CGPoint(x: 0, y: yPosition)
        textLayer.frame = CGRect(origin: newOrigin, size: textLayer.frame.size)
    }
}
