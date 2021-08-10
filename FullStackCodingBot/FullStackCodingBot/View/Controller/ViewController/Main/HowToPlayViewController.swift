import UIKit
import RxSwift

final class HowToPlayViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: HowToPlayViewModel!
    
    @IBOutlet weak var howToImageView: UIImageView!
    @IBOutlet weak var imagePageControl: UIPageControl!
    @IBOutlet weak var howToTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func bindViewModel() {
        cancelButton.rx.action = viewModel.cancelAction
    }
}

private extension HowToPlayViewController {
    
    private func setup() {
        setupImagePageControl()
        setupManual(from: 0)
    }
    
    private func setupImagePageControl() {
        imagePageControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: {[unowned self] in
                let current = self.imagePageControl.currentPage
                self.setupManual(from: current)
            }).disposed(by: rx.disposeBag)
    }
    
    private func setupManual(from index: Int) {
        let manual = viewModel.getCurrentManul(from: index)
        howToImageView.image = UIImage(named: manual.image)
        howToTextView.text = manual.text
    }
}
