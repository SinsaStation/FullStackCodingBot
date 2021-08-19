import UIKit

final class LoadingView: UIView {

    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        loadingLabel.font = UIFont.joystix(style: .body)
    }
    
    func setup() {
        alpha = 1
        loadingLabel.text = "Loading..."
        personImageView.image = UIImage(named: "story_person_sleep")
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func hide() {
        backgroundColor = .systemTeal
        loadingLabel.text = "Done!"
        personImageView.image = UIImage(named: "story_person_normal")
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
            UIView.animate(withDuration: 0.3) {
                self?.alpha = 0
            }
        }
    }
}
