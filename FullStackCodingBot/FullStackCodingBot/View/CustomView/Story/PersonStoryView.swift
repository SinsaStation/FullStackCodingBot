import UIKit

final class PersonStoryView: UIView {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var speakerImageView: UIImageView!
    @IBOutlet weak var scriptTextView: UITextView!
    @IBOutlet weak var speakerLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setFont()
    }
    
    private func setFont() {
        scriptTextView.font = UIFont.joystix(style: .body)
        speakerLabel.font = UIFont.joystix(style: .body)
        roleLabel.font = UIFont.joystix(style: .caption)
    }
    
    func show(with script: Script) {
        setImage(with: script.imageName)
        setTexts(with: script)
    }
    
    private func setImage(with imageName: String?) {
        let imageName = imageName ?? ""
        let speakerImage = UIImage(named: imageName)
        speakerImageView.image = speakerImage
        
        fadeIn(view: speakerImageView, duration: 0.6)
    }
    
    private func setTexts(with script: Script) {
        scriptTextView.text = script.line
        let speakerInfo = script.speaker?.info
        speakerLabel.text = speakerInfo?.name
        roleLabel.text = speakerInfo?.role
        
        fadeIn(view: scriptTextView, duration: 0.3)
    }
    
    private func fadeIn(view: UIView, duration: Double) {
        view.alpha = 0.0
        
        UIView.animate(withDuration: duration) {
            view.alpha = 1.0 
        }
    }
}
