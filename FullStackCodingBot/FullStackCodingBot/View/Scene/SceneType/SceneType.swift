import UIKit

protocol SceneType {
    func instantiate(from identifier: String) -> UIViewController
}
