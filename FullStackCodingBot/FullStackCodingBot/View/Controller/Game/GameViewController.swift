import UIKit

final class GameViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var buttonController: GameButtonController!
    @IBOutlet weak var unitPerspectiveView: UnitPerspectiveView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var rightUnitStackView: UIStackView!
    @IBOutlet weak var leftUnitStackView: UIStackView!
    
    var viewModel: GameViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameStart()
    }
    
    func bindViewModel() {
        buttonController.setupButton()
        buttonController.bind { [unowned self] direction in
            self.viewModel.moveUnitAction(to: direction)
            self.updateScoreLabel()
        }
        
        viewModel.logic
            .subscribe(onNext: { [weak self] logic in
                guard let logic = logic else { return }
                self?.buttonAction(to: logic)
            }).disposed(by: rx.disposeBag)
        
        cancelButton.rx.action = viewModel.cancelAction
    }
    
    private func updateScoreLabel() {
        scoreLabel.rx.text
            .asObserver()
            .onNext("\(viewModel.score)")
        
        // 임시
        update(unitStackView: leftUnitStackView, with: viewModel.leftStackUnits)
        update(unitStackView: rightUnitStackView, with: viewModel.rightStackUnits)
    }
    
    private func update(unitStackView: UIStackView, with storage: [Unit]) {
        for (index, subview) in unitStackView.arrangedSubviews.reversed().enumerated() {
            guard let imageView = subview as? UIImageView,
                  storage.count > index else { break }
            
            let imageName = storage[index].image
            imageView.image = UIImage(named: imageName)
        }
    }
    
    private func gameStart() {
        unitPerspectiveView.configure(with: viewModel.execute())
        updateScoreLabel()
    }
    
    private func buttonAction(to direction: Direction) {
        unitPerspectiveView.removeFirstUnit(to: direction)
        unitPerspectiveView.refillLastUnit(with: viewModel.newRandomUnit())
    }
}
