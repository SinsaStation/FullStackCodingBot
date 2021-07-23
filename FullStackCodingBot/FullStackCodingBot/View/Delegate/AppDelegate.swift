import UIKit
import GoogleMobileAds
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        let coordinator = SceneCoordinator(window: window!)
        let storage = ItemStorage()
        let database = DatabaseManager(Database.database().reference())
        let mainViewModel = MainViewModel(sceneCoordinator: coordinator, storage: storage, database: database)
        let mainScene = Scene.main(mainViewModel)
        coordinator.transition(to: mainScene, using: .root, with: StoryboardType.main, animated: false)
        return true
    }
}
