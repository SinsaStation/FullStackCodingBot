import UIKit
import RxCocoa

final class GameViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: GameViewModel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var buttonController: GameButtonController!
    @IBOutlet weak var unitPerspectiveView: UnitPerspectiveView!
    @IBOutlet weak var rightUnitStackView: UIStackView!
    @IBOutlet weak var leftUnitStackView: UIStackView!
    @IBOutlet weak var normalTimeView: TimeBarView!
    @IBOutlet weak var feverTimeView: FeverTimeBarView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var backgroundView: GameBackgroundView!
    private var feedbackGenerator: UINotificationFeedbackGenerator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        normalTimeView.setup()
    }
    
    func bindViewModel() {
        bindButtonController()
        bindScore()
        bindUnits()
        bindTimeProgress()
        bindGameStates()
        bindUserAction()
    }
    
    private func bindButtonController() {
        buttonController.setupButton()
        buttonController.bind { [unowned self] direction in
            self.viewModel.moveUnitAction(to: direction)
        }
    }
    
    private func bindScore() {
        viewModel.currentScore
            .map { "\($0)" }
            .asDriver(onErrorJustReturn: "")
            .drive(scoreLabel.rx.text)
            .disposed(by: rx.disposeBag)
    }
    
    private func bindUnits() {
        viewModel.newMemberUnit
            .subscribe(onNext: { [unowned self] newStackUnit in
                guard let newStackUnit = newStackUnit else { return }
                switch newStackUnit.direction {
                case .left:
                    self.updateImage(of: newStackUnit, to: self.leftUnitStackView)
                case .right:
                    self.updateImage(of: newStackUnit, to: self.rightUnitStackView)
                }
        }).disposed(by: rx.disposeBag)
        
        viewModel.newOnGameUnits
            .subscribe(onNext: { [unowned self] newUnits in
                self.setupPerspectiveView(newUnits)
        }).disposed(by: rx.disposeBag)
    }
    
    private func bindUserAction() {
        viewModel.userAction
            .subscribe(onNext: { [unowned self] status in
                guard let status = status else { return }
                switch status {
                case .correct(let direction):
                    self.checkRemove(to: direction)
                case .wrong:
                    self.backgroundView.playWrongMode()
                    self.normalTimeView.playWrongMode()
                    fallthrough
                case .feverWrong:
                    self.feedbackGenerator?.notificationOccurred(.error)
                }
        }).disposed(by: rx.disposeBag)
        
        pauseButton.rx.action = viewModel.pauseAction
    }
    
    private func bindTimeProgress() {
        viewModel.timeLeftPercentage
            .subscribe(onNext: { [unowned self] percentage in
                DispatchQueue.main.async {
                    self.normalTimeView.timeAdjust(to: percentage, for: 1)
                }
            }).disposed(by: rx.disposeBag)
    }
    
    private func bindGameStates() {
        viewModel.newGameStatus
            .subscribe(onNext: { [unowned self] gameStatus in
                switch gameStatus {
                case .new:
                    self.gameStart()
                case .pause:
                    assert(true)
                case .resume:
                    self.viewModel.startTimer()
                    self.normalTimeView.setup()
                }
        }).disposed(by: rx.disposeBag)
        
        viewModel.newFeverStatus
            .subscribe(onNext: { [unowned self] feverStatus in
                self.setupTimeView(isFeverOn: feverStatus)
        }).disposed(by: rx.disposeBag)
    }
}

// MARK: - Setup
private extension GameViewController {
    private func setup() {
        setupFeedbackGenerator()
    }
    
    private func setupFeedbackGenerator() {
        feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator?.prepare()
    }
    
    private func setupPerspectiveView(_ newUnits: [Unit]?) {
        guard let newUnits = newUnits else { return }
        let unitImages = newUnits.map { $0.image }
        unitPerspectiveView.configure(with: unitImages)
    }
    
    private func setupTimeView(isFeverOn: Bool) {
        DispatchQueue.main.async {
            self.normalTimeView.isHidden = isFeverOn
            self.feverTimeView.isHidden = !isFeverOn
            
            if isFeverOn {
                self.feverTimeView.setup()
                self.backgroundView.startFever()
            } else {
                self.backgroundView.stopFever()
            }
        }
    }
}

// MARK: Game Logic Methods
private extension GameViewController {
    private func gameStart() {
        clearViews()
        viewModel.execute()
    }
    
    private func clearViews() {
        clear(rightUnitStackView)
        clear(leftUnitStackView)
        unitPerspectiveView.clearAll()
    }

    private func clear(_ stackView: UIStackView) {
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
    
    private func checkRemove(to direction: Direction?) {
        guard let direction = direction else { return }
        unitPerspectiveView.removeFirstUnitLayer(to: direction)
    }
}
