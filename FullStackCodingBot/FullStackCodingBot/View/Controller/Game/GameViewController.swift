import UIKit

final class GameViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var buttonController: GameButtonController!
    @IBOutlet weak var unitPerspectiveView: UnitPerspectiveView!
    @IBOutlet weak var cancelButton: UIButton!
    
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
        updateScoreLabel()
    }
    
    private func updateScoreLabel() {
        scoreLabel.rx.text
            .asObserver()
            .onNext("\(viewModel.score)")
    }
    
    private func gameStart() {
        unitPerspectiveView.configure(with: viewModel.execute())
    }
    
    private func buttonAction(to direction: Direction) {
        unitPerspectiveView.removeFirstUnit(to: direction)
        unitPerspectiveView.refillLastUnit(with: viewModel.newRandomUnit())
    }
}
