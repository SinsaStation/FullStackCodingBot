import UIKit

final class GameViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var unitPerspectiveView: UnitPerspectiveView!
    
    var viewModel: GameViewModel!
    
    private let unitCount = 8
    private let allUnits = [Unit(image: .swift), Unit(image: .kotlin), Unit(image: .java), Unit(image: .cPlusPlus)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameStart()
    }
    
    func bindViewModel() {
        print("\(self)")
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
}
