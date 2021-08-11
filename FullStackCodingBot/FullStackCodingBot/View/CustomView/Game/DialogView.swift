import UIKit

final class DialogView: UIView {
    
    @IBOutlet weak var textBox: UIView!
    @IBOutlet weak var speakerImageView: UIImageView!
    @IBOutlet weak var scriptTextView: UITextView!
    
    func show(with script: Script) {
        fadeIn(view: textBox, duration: 0.5)
        setImage(with: script.imageName)
        setTexts(with: script)
    }
    
    private func setImage(with imageName: String?) {
        let imageName = imageName ?? ""
        let speakerImage = UIImage(named: imageName)
        speakerImageView.image = speakerImage
        
        fadeIn(view: speakerImageView, duration: 0.7)
    }
    
    private func setTexts(with script: Script) {
        scriptTextView.text = script.line
        fadeIn(view: scriptTextView, duration: 0.5)
    }
    
    private func fadeIn(view: UIView, duration: Double) {
        view.alpha = 0.0
        
        UIView.animate(withDuration: duration) {
            view.alpha = 1.0
        }
    }
}
