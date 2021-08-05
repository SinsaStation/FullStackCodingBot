import UIKit

final class LevelUpButton: UIButton {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var requiredMoneyLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
        
    func configure(_ unit: Unit) {
        DispatchQueue.main.async { [unowned self] in
            self.requiredMoneyLabel.text = "\(unit.level*100)"
        }
        
    }
    
    private func loadXib() {
        let name = String(describing: type(of: self))
        Bundle.main.loadNibNamed(name, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
