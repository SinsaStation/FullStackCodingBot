import UIKit

final class HowToPlayViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: HowToPlayViewModel!
    
    @IBOutlet weak var howToImageView: UIImageView!
    @IBOutlet weak var imagePageControl: UIPageControl!
    @IBOutlet weak var howToTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        cancelButton.rx.action = viewModel.cancelAction
    }
}
