import UIKit

final class MainItemView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    private func loadXib() {
        let name = String(describing: type(of: self))
        Bundle.main.loadNibNamed(name, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
