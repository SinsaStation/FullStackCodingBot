import UIKit

final class TypeWriterView: TextPresentView {

    private let delayPerLetter: Double = 0.08
    
    override func show(text fullText: String, color: UIColor = .match) {
        super.show(text: fullText, color: color)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        startTyping(text: fullText)

        CATransaction.commit()
    }
    
    private func startTyping(text fullText: String) {
        let letters = fullText.map { String($0) }
        
        (0..<letters.count).forEach { [weak self] count in
            let currentDelay = delayPerLetter * Double(count)
            
            Timer.scheduledTimer(withTimeInterval: currentDelay, repeats: false) { _ in
                self?.changeText(for: count, with: letters)
            }
        }
    }
    
    private func changeText(for count: Int, with letters: [String]) {
        let currentText = text(for: count, with: letters)
        textLayer.string = currentText
    }

    private func text(for currentCount: Int, with letters: [String]) -> String {
        return (0...currentCount).map { letters[$0] }.joined()
    }
}
