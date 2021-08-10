import UIKit

class TextPresentView: UIView {
    
    private(set) lazy var textLayer: CATextLayer = {
        let textLayer = CATextLayer()
        textLayer.font = UIFont(name: fontName, size: 16)
        textLayer.alignmentMode = alignMode
        textLayer.foregroundColor = defaultTextColor.cgColor
        layer.addSublayer(textLayer)
        return textLayer
    }()
    
    private var alignMode: CATextLayerAlignmentMode = .center
    private var fontName = Font.joystix
    private let defaultTextColor = UIColor(named: "digitalgreen") ?? UIColor.green
    private let defaultLetterCount = 15
    private let maxFontSize: CGFloat = 17
    private let lineSeparator = "\n"
    
    func setup(fontName: String, alignMode: CATextLayerAlignmentMode) {
        self.fontName = fontName
        self.alignMode = alignMode
    }
    
    func layoutSubviews(with text: String) {
        super.layoutSubviews()
        resizeTextLayer(with: text)
    }
    
    func show(text fullText: String) {
        setTextLayer(with: fullText)
    }
    
    private func setTextLayer(with text: String) {
        textLayer.alignmentMode = self.alignMode
        textLayer.font = UIFont(name: fontName, size: maxFontSize)
        textLayer.string = text
        resizeTextLayer(with: text)
    }
    
    private func resizeTextLayer(with text: String) {
        textLayer.fontSize = newFontSize(for: text)
        adjustTextLayerFrameToCenter(for: text)
    }
    
    private func newFontSize(for text: String) -> CGFloat {
        let maxLetterCount = maxLetterCount(in: text)
        let newFontSize = bounds.width * 0.95 / CGFloat(maxLetterCount)
        let adjustedFontSize = newFontSize < maxFontSize ? newFontSize : maxFontSize
        return adjustedFontSize
    }
    
    private func maxLetterCount(in text: String) -> Int {
        let letterCountsPerLine = text.components(separatedBy: lineSeparator).map { $0.count }
        let maxLetterCount = letterCountsPerLine.max() ?? defaultLetterCount
        let adjustedMaxCount = maxLetterCount > defaultLetterCount ? maxLetterCount : defaultLetterCount
        return adjustedMaxCount
    }
    
    private func adjustTextLayerFrameToCenter(for fullText: String) {
        let newOrigin = origin(for: self.alignMode, fullText)
        textLayer.frame = CGRect(origin: newOrigin, size: bounds.size)
    }
    
    private func origin(for alignMode: CATextLayerAlignmentMode, _ text: String) -> CGPoint {
        switch alignMode {
        case .center:
            let lineCount = text.components(separatedBy: lineSeparator).count
            let currentFont = textLayer.font as? UIFont ?? UIFont.systemFont(ofSize: maxFontSize)
            let fontHeight = currentFont.capHeight
            let totalTextHeight = fontHeight * CGFloat(lineCount)
            let yPosition =  (bounds.height - totalTextHeight * 1.5) / 2
            return CGPoint(x: 0, y: yPosition)
        default:
            let maxLetterCount = maxLetterCount(in: text)
            let currentFontSize = newFontSize(for: text)
            let maxWidth = CGFloat(maxLetterCount) * currentFontSize
            let xPosition = (bounds.width - maxWidth * 0.5) / 2
            return CGPoint(x: xPosition, y: 0)
        }
    }
}
