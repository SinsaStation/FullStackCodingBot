import UIKit

class TextPresentView: UIView {
    
    private(set) lazy var textLayer: CATextLayer = {
        let textLayer = CATextLayer()
        textLayer.font = UIFont(name: fontName, size: Defaults.maxFont)
        textLayer.alignmentMode = alignMode
        textLayer.foregroundColor = Defaults.textColor.cgColor
        layer.addSublayer(textLayer)
        return textLayer
    }()
    
    private var alignMode: CATextLayerAlignmentMode = .center
    private var fontName = Font.joystix
    
    enum Defaults {
        static let textColor = UIColor(named: "digitalgreen") ?? UIColor.green
        static let wrongColor = UIColor(named: "red") ?? UIColor.red
        static let letterCount = 15
        static let maxFont: CGFloat = 17
        static let minFont: CGFloat = 12
    }

    enum Seperator {
        static let line = "\n"
        static let tab = "\t"
        static let space = " "
    }
    
    func setup(fontName: String, alignMode: CATextLayerAlignmentMode) {
        self.fontName = fontName
        self.alignMode = alignMode
    }
    
    func layoutSubviews(with text: String) {
        super.layoutSubviews()
        resizeTextLayer(with: text)
    }
    
    func show(text fullText: String, color: UIColor = Defaults.textColor) {
        setTextLayer(with: fullText, color: color)
    }
    
    private func setTextLayer(with text: String, color: UIColor) {
        textLayer.alignmentMode = self.alignMode
        textLayer.font = UIFont(name: fontName, size: Defaults.maxFont)
        textLayer.string = text
        textLayer.foregroundColor = color.cgColor
        resizeTextLayer(with: text)
    }
    
    private func resizeTextLayer(with text: String) {
        textLayer.fontSize = newFontSize(for: text)
        adjustTextLayerFrameToCenter(for: text)
    }
    
    private func newFontSize(for text: String) -> CGFloat {
        let maxLetterCount = maxLetterCount(in: text)
        let newFontSize = bounds.width * 0.95 / CGFloat(maxLetterCount)
        var adjustedFontSize = newFontSize < Defaults.maxFont ? newFontSize : Defaults.maxFont
        adjustedFontSize = newFontSize > Defaults.minFont ? newFontSize : Defaults.minFont
        return adjustedFontSize
    }
    
    private func maxLetterCount(in text: String) -> Int {
        let letterCountsPerLine = text
            .components(separatedBy: Seperator.line)
            .filter { ![Seperator.space, Seperator.tab].contains($0) }
            .map { $0.count }
        let maxLetterCount = letterCountsPerLine.max() ?? Defaults.letterCount
        let adjustedMaxCount = maxLetterCount > Defaults.letterCount ? maxLetterCount : Defaults.letterCount
        return adjustedMaxCount
    }
    
    private func adjustTextLayerFrameToCenter(for fullText: String) {
        let newOrigin = origin(for: self.alignMode, fullText)
        textLayer.frame = CGRect(origin: newOrigin, size: bounds.size)
    }
    
    private func origin(for alignMode: CATextLayerAlignmentMode, _ text: String) -> CGPoint {
        switch alignMode {
        case .center:
            let lineCount = text.components(separatedBy: Seperator.line).count
            let currentFont = textLayer.font as? UIFont ?? UIFont.systemFont(ofSize: Defaults.maxFont)
            let fontHeight = currentFont.capHeight
            let totalTextHeight = fontHeight * CGFloat(lineCount)
            let yPosition =  (bounds.height - totalTextHeight * 1.5) / 2
            return CGPoint(x: 0, y: yPosition)
        default:
            let maxWidth = CGFloat(maxLetterCount(in: text)) * newFontSize(for: text)
            let xPosition = (bounds.width - maxWidth * 0.5) / 2
            return CGPoint(x: xPosition, y: 0)
        }
    }
}
