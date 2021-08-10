import UIKit

final class HowToPlayViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: HowToPlayViewModel!
    
    @IBOutlet weak var howToImageView: UIImageView!
    @IBOutlet weak var imagePageControl: UIPageControl!
    @IBOutlet weak var howToTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
    }
}
