import UIKit

final class GameViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var buttonController: GameButtonController!
    @IBOutlet weak var unitPerspectiveView: UnitPerspectiveView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var rightUnitStackView: UIStackView!
    @IBOutlet weak var leftUnitStackView: UIStackView!
    @IBOutlet weak var timeView: TimeProgressView!
    
    var viewModel: GameViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameStart()
    }
    
    private func gameStart() {
        unitPerspectiveView.configure(with: viewModel.execute())
    }
    
    func bindViewModel() {
        buttonController.setupButton()
        buttonController.bind { [unowned self] direction in
            self.viewModel.moveUnitAction(to: direction)
        }
        
        cancelButton.rx.action = viewModel.cancelAction
        
        viewModel.logic
            .subscribe(onNext: { [weak self] logic in
                guard let logic = logic else { return }
                self?.buttonAction(to: logic)
            }).disposed(by: rx.disposeBag)
        
        viewModel.score
            .scan(0) { $0 + $1 }
            .subscribe(onNext: { [weak self] score in
                self?.scoreLabel.text = "\(score)"
        }).disposed(by: rx.disposeBag)
        
        viewModel.stackMemberUnit
            .subscribe(onNext: { [weak self] newStackUnit in
                guard let self = self,
                      let newStackUnit = newStackUnit else { return }
                switch newStackUnit.direction {
                case .left:
                    self.updateImage(of: newStackUnit, to: self.leftUnitStackView)
                case .right:
                    self.updateImage(of: newStackUnit, to: self.rightUnitStackView)
                }
        }).disposed(by: rx.disposeBag)
        
        timeView.observedProgress = viewModel.timeProgress
    }
    
    private func buttonAction(to direction: Direction) {
        unitPerspectiveView.removeFirstUnit(to: direction)
        unitPerspectiveView.refillLastUnit(with: viewModel.newRandomUnit())
    }
    
    private func updateImage(of newStackMember: StackMemberUnit, to stackView: UIStackView) {
        let subviews = stackView.arrangedSubviews
        let targetIndex = subviews.count-newStackMember.order-1
        
        guard let imageView = subviews[targetIndex] as? UIImageView else { return }
        
        let unitImage = UIImage(named: newStackMember.content.image)
        imageView.image = unitImage
    }
}
