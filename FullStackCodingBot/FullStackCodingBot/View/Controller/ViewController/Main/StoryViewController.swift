import UIKit
import RxSwift
import RxCocoa

final class StoryViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: StoryViewModel!
    
    @IBOutlet weak var storyView: UIView!
    @IBOutlet weak var speakerLabel: UILabel!
    @IBOutlet weak var scriptTextView: UITextView!
    
    private let story = StoryManager.allCases
    
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
        if index == 7 {
            viewModel.makeMoveActionToMain()
            return
        }
        let storyInfo = story[index]
        speakerLabel.text = storyInfo.content.name
        scriptTextView.text = storyInfo.content.script
    }
}
