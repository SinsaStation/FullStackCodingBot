import UIKit

enum FontStyle {
    case caption
    case body
    case title3
    case title2
    case title1
    case largeTitle
    
    var size: CGFloat {
        switch self {
        case .caption:
            return ScreenSize.height * 0.018
        case .body:
            return ScreenSize.height * 0.022
        case .title3:
            return ScreenSize.height * 0.03
        case .title2:
            return ScreenSize.height * 0.05
        case .title1:
            return ScreenSize.height * 0.06
        case .largeTitle:
            return ScreenSize.height * 0.1
        }
    }
}

enum Font {
    static let joystix = "JoystixMonospace-Regular"
    static let neo = "NeoDunggeunmo-Regular"
}

extension UIFont {
    static func joystix(style: FontStyle) -> UIFont {
        let size = style.size
        return UIFont(name: Font.joystix, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func neoDunggeunmo(style: FontStyle) -> UIFont {
        let size = style.size
        return UIFont(name: Font.neo, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
