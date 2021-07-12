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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameStart()
    }
    
    private func gameStart() {
        clear(stackView: rightUnitStackView)
        clear(stackView: leftUnitStackView)
        unitPerspectiveView.clearAll()
        viewModel.execute()
    }

    func bindViewModel() {
        buttonController.setupButton()
        buttonController.bind { [unowned self] direction in
            self.viewModel.moveUnitAction(to: direction)
        }
        
        cancelButton.rx.action = viewModel.cancelAction
        
        viewModel.newDirection
            .subscribe(onNext: { [weak self] direction in
                guard let self = self,
                      let direction = direction else { return }
                self.unitPerspectiveView.removeFirstUnitLayer(to: direction)
        }).disposed(by: rx.disposeBag)
        
        viewModel.scoreAdded
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let newScore = self.viewModel.currentScore
                self.scoreLabel.text = "\(newScore)"
        }).disposed(by: rx.disposeBag)
        
        viewModel.newMemberUnit
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
        
        viewModel.newOnGameUnits
            .subscribe(onNext: { [weak self] newUnits in
                guard let self = self,
                      let newUnits = newUnits else { return }
                let unitImages = newUnits.map { $0.image }
                self.unitPerspectiveView.configure(with: unitImages)
        }).disposed(by: rx.disposeBag)
        
        timeView.observedProgress = viewModel.timeProgress
    }
    
    private func clear(stackView: UIStackView) {
        stackView.arrangedSubviews.forEach { view in
            guard let imageView = view as? UIImageView else { return }
            imageView.image = nil
        }
    }
    
    private func updateImage(of newStackMember: StackMemberUnit, to stackView: UIStackView) {
        let subviews = stackView.arrangedSubviews
        let targetIndex = subviews.count-newStackMember.order-1
        
        guard let imageView = subviews[targetIndex] as? UIImageView else { return }
        
        let unitImage = UIImage(named: newStackMember.content.image)
        imageView.image = unitImage
    }
}
