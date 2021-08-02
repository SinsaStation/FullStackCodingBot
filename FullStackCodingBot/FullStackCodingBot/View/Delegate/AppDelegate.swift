import UIKit
import GoogleMobileAds
import Firebase
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let storage = PersistenceStorage()
    private let adStorage = AdStorage()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        setAdMobs()
        setAudioSession()
        presentMainViewController()
        return true
    }
    
    private func setAdMobs() {
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [kGADSimulatorID]
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    private func setAudioSession() {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        try? AVAudioSession.sharedInstance().setActive(true)
        SoundStation.shared.musicPlay(type: .main)
    }
    
    private func presentMainViewController() {
        let coordinator = SceneCoordinator(window: window!)
        let database = DatabaseManager(Database.database().reference())
        let mainViewModel = MainViewModel(sceneCoordinator: coordinator, storage: storage, adStorage: adStorage, database: database)
        let mainScene = Scene.main(mainViewModel)
        coordinator.transition(to: mainScene, using: .root, with: StoryboardType.main, animated: false)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let database = DatabaseManager(Database.database().reference())
        let networkDTO = NetworkDTO(units: storage.itemList(), money: storage.myMoney(), score: storage.myHighScore(), ads: adStorage.currentInformation())
        database.updateDatabase(networkDTO)
    }
}
