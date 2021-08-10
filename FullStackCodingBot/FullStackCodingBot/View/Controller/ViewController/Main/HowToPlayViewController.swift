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

// MARK: SetUp
private extension HowToPlayViewController {
    
    private func setup() {
        setupImagePageControl()
        setupManual(from: 0)
        setupSwipeGesture()
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
    
    private func setupSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        howToImageView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        howToImageView.addGestureRecognizer(swipeRight)
    }
}

// MARK: Action
private extension HowToPlayViewController {
    
    @objc private func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        guard let swipeGesture = gesture as? UISwipeGestureRecognizer else {
            return
        }
        
        switch swipeGesture.direction {
        case .left:
            guard imagePageControl.currentPage < 4 else { return }
            imagePageControl.currentPage += 1
        
        case .right:
            guard imagePageControl.currentPage > 0 else { return }
            imagePageControl.currentPage -= 1
        
        default:
            break
        }
        setupManual(from: imagePageControl.currentPage)
    }
}
