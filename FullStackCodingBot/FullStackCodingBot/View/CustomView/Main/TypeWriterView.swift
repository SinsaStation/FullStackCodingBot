import UIKit

final class TypeWriterView: UIView {

    private let textColor = UIColor(named: "digitalgreen") ?? UIColor.green
    private let fontSize: CGFloat = 17 // view.bound.width * 0.04
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
    
    func startTyping(text fullText: String, duration: Double) {
        adjustFrameToCenter(for: fullText)
        
        let totalCount = fullText.count
        let delayPerLetter = duration / Double(totalCount)
        let letters = fullText.map { String($0) }
        
        for count in 0..<totalCount {
            let currentDelay = delayPerLetter * Double(count)
            Timer.scheduledTimer(withTimeInterval: currentDelay, repeats: false) { [weak self] _ in
                self?.changeText(for: count, with: letters)
            }
        }
    }
    
    private func adjustFrameToCenter(for fullText: String) {
        let lineCount = fullText.components(separatedBy: "\n").count
        let fontHeight = font.capHeight
        let totalTextHeight = fontHeight * CGFloat(lineCount)
        let yOffset = (layer.bounds.size.height-totalTextHeight*1.5)/2
        textLayer.frame = textLayer.frame.offsetBy(dx: 0, dy: yOffset)
    }
    
    private func changeText(for count: Int, with letters: [String]) {
        let currentText = text(for: count, with: letters)
        textLayer.string = currentText
    }

    private func text(for currentCount: Int, with letters: [String]) -> String {
        return (0...currentCount).map { letters[$0] }.joined()
    }
}
