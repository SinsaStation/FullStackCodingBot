import UIKit

enum ScreenSize {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static let full = CGSize(width: ScreenSize.width, height: ScreenSize.height)
}
