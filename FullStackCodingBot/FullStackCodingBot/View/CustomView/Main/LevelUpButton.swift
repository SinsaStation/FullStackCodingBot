import UIKit

final class LevelUpButton: UIButton {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var requiredMoneyLabel: UILabel!
    @IBOutlet weak var upgradeLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXib()
        setFont()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        setFont()
    }
        
    func configure(_ unit: Unit) {
        self.requiredMoneyLabel.text = "\(unit.level*100)"
    }
    
    private func loadXib() {
        let name = String(describing: type(of: self))
        Bundle.main.loadNibNamed(name, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setFont() {
        requiredMoneyLabel.font = UIFont.joystix(style: .title3)
        upgradeLabel.font = UIFont.joystix(style: .caption)
    }
}
