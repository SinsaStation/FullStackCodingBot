import UIKit
import RxSwift
import RxCocoa

final class StoryViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: StoryViewModel!
    
    @IBOutlet weak var personStoryView: PersonStoryView!
    @IBOutlet weak var fullImageStoryView: FullImageStoryView!
    private let story = Script.all
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        viewModel.setupStoryTimer()
        
        viewModel.storyTimer
            .subscribe(onNext: { [unowned self] index in
                self.setTextInfo(index)
            }).disposed(by: rx.disposeBag)
    }
    
    private func setTextInfo(_ index: Int) {
        if index == story.count {
            viewModel.makeMoveActionToMain()
            return
        }
        let script = story[index]
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
