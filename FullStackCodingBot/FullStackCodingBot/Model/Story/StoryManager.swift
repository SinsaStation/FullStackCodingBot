import Foundation

final class StoryManager {
    
    private let story: [Script]
    private var currentPage: Int
    private lazy var timeLine: [Double] = {
        var timeLine = [Double]()
        (0..<story.count).forEach {
            let timeStamp = (0...$0).map { story[$0].runTime() }.reduce(0, +)
            timeLine.append(timeStamp)
        }
        return timeLine
    }()
    
    init(story: [Script] = Script.story, currentPage: Int = 0) {
        self.story = story
        self.currentPage = currentPage
    }
    
    func current() -> Script? {
        return currentPage >= story.count ? nil : story[currentPage]
    }
    
    func status(for currentTime: Double) -> StoryStatus {
        guard currentPage < story.count else { return .end }
        let currentTimeStamp = timeLine[currentPage]
        guard currentTime >= currentTimeStamp else { return .stay }
        currentPage += 1
        return current() != nil ? .new(current()!) : .end
    }
    
    enum StoryStatus {
        case new(Script)
        case stay
        case end
    }
}
