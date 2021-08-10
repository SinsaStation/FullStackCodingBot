import UIKit
import RxSwift
import RxCocoa

final class StoryViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: StoryViewModel!
    
    @IBOutlet weak var personStoryView: PersonStoryView!
    @IBOutlet weak var fullImageStoryView: FullImageStoryView!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func bindViewModel() {
        viewModel.setupStoryTimer()
        
        viewModel.script
            .subscribe(onNext: { [unowned self] script in
                guard let script = script else { return }
                self.play(script)
            }).disposed(by: rx.disposeBag)
    }
    
    private func setup() {
        skipButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.endOfStory()
            }).disposed(by: rx.disposeBag)
    }
    
    private func play(_ script: Script) {
        script.speaker == nil ? enableFullImageView(with: script) : enablePersonView(with: script)
    }

    private func enableFullImageView(with script: Script) {
        changePersonView(to: false)
        fullImageStoryView.show(with: script)
    }
    
    private func enablePersonView(with script: Script) {
        changePersonView(to: true)
        personStoryView.show(with: script)
    }
    
    private func changePersonView(to status: Bool) {
        personStoryView.isHidden = !status
        fullImageStoryView.isHidden = status
    }
}
