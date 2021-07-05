import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let coordinator = SceneCoordinator(window: window!)
        let mainViewModel = MainViewModel(sceneCoordinator: coordinator)
        let mainScene = Scene.main(mainViewModel)
        coordinator.transition(to: mainScene, using: .root, animated: false)
    }

}

