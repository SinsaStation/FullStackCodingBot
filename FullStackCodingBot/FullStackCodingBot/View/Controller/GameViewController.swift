import UIKit

final class GameViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var unitPerspectiveView: UnitPerspectiveView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var viewModel: GameViewModel!
    
    private let unitCount = 8
    private let allUnits = [Unit(image: .swift, level: 1, count: 1),
                            Unit(image: .kotlin, level: 1, count: 1),
                            Unit(image: .java, level: 1, count: 1),
                            Unit(image: .cPlusPlus, level: 1, count: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        buttonAction()
    }
    
    @IBAction func rightButtonTouched(_ sender: UIButton) {
        buttonAction()
    }
    
    private func buttonAction() {
        unitPerspectiveView.removeFirstUnit()
        unitPerspectiveView.refillLastUnit(with: newRandomUnit())
        unitPerspectiveView.fillUnits()
    }
    
    private func generateStartingUnits(count: Int) -> [Unit] {
        return (0..<count).map{ allUnits[$0 % 4] }
    }
    
    private func newRandomUnit() -> Unit {
        return allUnits.randomElement()!
    }
    
    @IBAction func backButtonTouched(_ sender: Any) {
        
    }
}
