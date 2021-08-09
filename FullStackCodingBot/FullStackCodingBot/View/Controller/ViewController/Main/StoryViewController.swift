import UIKit
import RxSwift
import RxCocoa

final class StoryViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: StoryViewModel!
    
    @IBOutlet weak var personStoryView: PersonStoryView!
    @IBOutlet weak var fullImageStoryView: FullImageStoryView!

    func bindViewModel() {
        viewModel.setupStoryTimer()
        
        viewModel.script
            .subscribe(onNext: { [unowned self] script in
                guard let script = script else { return }
                self.play(script)
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
