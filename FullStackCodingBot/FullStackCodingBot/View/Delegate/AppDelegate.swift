import UIKit
import GoogleMobileAds
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let storage = PersistenceStorage()
    private let adStorage = AdStorage()
    private let userDefaults = UserDefaults.standard
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [kGADSimulatorID]
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        let settings = !userDefaults.bool(forKey: IdentifierUD.hasLaunchedOnce) ? true : userDefaults.bool(forKey: IdentifierUD.bgmState)
        let coordinator = SceneCoordinator(window: window!)
        let database = DatabaseManager(Database.database().reference())
        let mainViewModel = MainViewModel(sceneCoordinator: coordinator, storage: storage, adStorage: adStorage, database: database, bgmState: settings)
        let mainScene = Scene.main(mainViewModel)
        coordinator.transition(to: mainScene, using: .root, with: StoryboardType.main, animated: false)
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let database = DatabaseManager(Database.database().reference())
        let networkDTO = NetworkDTO(units: storage.itemList(), money: storage.myMoney(), score: storage.myHighScore(), ads: adStorage.currentInformation())
        database.updateDatabase(networkDTO)
    }
}
