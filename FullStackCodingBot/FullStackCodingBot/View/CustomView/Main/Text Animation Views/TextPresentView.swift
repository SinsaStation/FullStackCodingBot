import UIKit

class TextPresentView: UIView {
    
    private(set) lazy var textLayer: CATextLayer = {
        let textLayer = CATextLayer()
        textLayer.font = UIFont(name: Font.joystix, size: 16)
        textLayer.alignmentMode = .center
        textLayer.foregroundColor = defaultTextColor.cgColor
        layer.addSublayer(textLayer)
        return textLayer
    }()
    
    private let defaultTextColor = UIColor(named: "digitalgreen") ?? UIColor.green
    private let defaultLetterCount = 15
    private let maxFontSize: CGFloat = 17
    private let lineSeparator = "\n"
    
    func layoutSubviews(with text: String) {
        super.layoutSubviews()
        resizeTextLayer(with: text)
    }
    
    func show(text fullText: String) {
        setTextLayer(with: fullText)
    }
    
    private func setTextLayer(with text: String) {
        textLayer.string = text
        resizeTextLayer(with: text)
    }
    
    private func resizeTextLayer(with text: String) {
        textLayer.fontSize = newFontSize(for: text)
        adjustTextLayerFrameToCenter(for: text)
    }
    
    private func newFontSize(for text: String) -> CGFloat {
        let letterCountsPerLine = text.components(separatedBy: lineSeparator).map { $0.count }
        let maxLetterCount = letterCountsPerLine.max() ?? defaultLetterCount
        let adjustedMaxCount = maxLetterCount > defaultLetterCount ? maxLetterCount : defaultLetterCount
        let newFontSize = bounds.width * 0.95 / CGFloat(adjustedMaxCount)
        let adjustedFontSize = newFontSize < maxFontSize ? newFontSize : maxFontSize
        return adjustedFontSize
    }
    
    private func adjustTextLayerFrameToCenter(for fullText: String) {
        let lineCount = fullText.components(separatedBy: lineSeparator).count
        let currentFont = textLayer.font as? UIFont ?? UIFont()
        let fontHeight = currentFont.capHeight
        let totalTextHeight = fontHeight * CGFloat(lineCount)
        let yPosition = (bounds.height - totalTextHeight * 1.5) / 2
        let newOrigin = CGPoint(x: .zero, y: yPosition)
        textLayer.frame = CGRect(origin: newOrigin, size: bounds.size)
    }
}
