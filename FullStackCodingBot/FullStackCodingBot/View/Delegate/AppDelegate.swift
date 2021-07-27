import UIKit
import GoogleMobileAds
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let storage = PersistenceStorage()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [kGADSimulatorID]
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        let coordinator = SceneCoordinator(window: window!)
        let database = DatabaseManager(Database.database().reference())
        let adStorage = AdStorage()
        let mainViewModel = MainViewModel(sceneCoordinator: coordinator, storage: storage, adStorage: adStorage, database: database)
        mainViewModel.fetchGameData(firstLaunched: UserDefaults.standard.bool(forKey: IdentifierUD.hasLaunchedOnce), units: Unit.initialValues(), money: 0)
        let mainScene = Scene.main(mainViewModel)
        coordinator.transition(to: mainScene, using: .root, with: StoryboardType.main, animated: false)
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let database = DatabaseManager(Database.database().reference())
        database.updateDatabase(storage.itemList())
    }
}
