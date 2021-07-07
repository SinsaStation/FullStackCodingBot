import UIKit

final class GameViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var unitPerspectiveView: UnitPerspectiveView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var viewModel: GameViewModel!
    
    private let unitCount = 8
    private let allUnits = [
        Unit(info: .cPlusPlus, level: 1),
        Unit(info: .java, level: 1),
        Unit(info: .swift, level: 3),
        Unit(info: .kotlin, level: 1)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameStart()
    }
    
    func bindViewModel() {
        cancelButton.rx.action = viewModel.cancelAction
    }
    
    private func gameStart() {
        let startingUnits = generateStartingUnits(count: unitCount)
        unitPerspectiveView.configure(with: startingUnits)
        unitPerspectiveView.fillUnits()
    }
    
    @IBAction func leftButtonTouched(_ sender: UIButton) {
        buttonAction(to: .left)
    }
    
    @IBAction func rightButtonTouched(_ sender: UIButton) {
        buttonAction(to: .right)
    }
    
    private func buttonAction(to direction: Direction) {
        unitPerspectiveView.removeFirstUnit(to: direction)
        unitPerspectiveView.refillLastUnit(with: newRandomUnit())
        unitPerspectiveView.fillUnits()
    }
    
    private func generateStartingUnits(count: Int) -> [Unit] {
        return (0..<count).map { allUnits[$0 % 4] }
    }
    
    private func newRandomUnit() -> Unit {
        return allUnits.randomElement()!
    }
    
    @IBAction func backButtonTouched(_ sender: Any) {
        
    }
}
