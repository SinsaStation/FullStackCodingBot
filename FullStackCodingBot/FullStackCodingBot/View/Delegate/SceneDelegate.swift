import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let coordinator = SceneCoordinator(window: window!)
        let storage = ItemStorage()
        let mainViewModel = MainViewModel(sceneCoordinator: coordinator, storage: storage)
        let mainScene = Scene.main(mainViewModel)
        coordinator.transition(to: mainScene, using: .root, animated: false)
    }

}

