import UIKit
import RxSwift

final class HowToPlayViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: HowToPlayViewModel!
    
    @IBOutlet var directionButtonController: DirectionButtonController!
    @IBOutlet weak var howToImageView: UIImageView!
    @IBOutlet weak var imagePageControl: UIPageControl!
    @IBOutlet weak var howToTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func bindViewModel() {
        directionButtonController.setupButton()
        directionButtonController.bind { [unowned self] direction in
            self.viewModel.moveToPage(from: direction)
        }
        
        viewModel.currentPage
            .asDriver()
            .drive(imagePageControl.rx.currentPage)
            .disposed(by: rx.disposeBag)
        
        viewModel.currentManual
            .subscribe(onNext: { [unowned self] manual in
                self.setManual(from: manual)
            }).disposed(by: rx.disposeBag)
        
        imagePageControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.currentPage.accept(imagePageControl.currentPage)
            }).disposed(by: rx.disposeBag)
        
        cancelButton.rx.action = viewModel.cancelAction
    }
}

// MARK: SetUp
private extension HowToPlayViewController {
    
    private func setup() {
        setupSwipeGesture()
        viewModel.setCurrentManual()
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
        case .left: viewModel.moveToPage(from: DirectionType.right)
        case .right: viewModel.moveToPage(from: DirectionType.left)
        default: break
        }
    }
    
    private func setManual(from info: Manual) {
        howToImageView.image = UIImage(named: info.image)
        howToTextView.text = info.text
    }
}
