import UIKit
import GoogleMobileAds
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [kGADSimulatorID]
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        let coordinator = SceneCoordinator(window: window!)
        let storage = PersistenceStorage()
        if !UserDefaults.standard.bool(forKey: IdentifierUD.hasLaunchedOnce) {
            storage.initializeData(Unit.initialValues(), 0)
        } else {
            storage.fetchStoredData()
        }
        let database = DatabaseManager(Database.database().reference())
        let adStorage = AdStorage()
        let mainViewModel = MainViewModel(sceneCoordinator: coordinator, storage: storage, adStorage: adStorage, database: database)
        let mainScene = Scene.main(mainViewModel)
        coordinator.transition(to: mainScene, using: .root, with: StoryboardType.main, animated: false)
        return true
    }
}
