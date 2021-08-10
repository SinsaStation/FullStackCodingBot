import UIKit
import GoogleMobileAds
import Firebase
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let storage = PersistenceStorage()
    private let adStorage = AdStorage()
    private let userDefaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        setAdMobs()
        setAudioSession()
        presentMainViewController()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let database = DatabaseManager(Database.database().reference())
        let networkDTO = NetworkDTO(units: storage.itemList(), money: storage.myMoney(), score: storage.myHighScore(), ads: adStorage.currentInformation())
        if storage.itemList().isEmpty { return }
        database.updateDatabase(networkDTO)
    }
}

// MARK: Setup
private extension AppDelegate {
    
    private func setAdMobs() {
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [kGADSimulatorID]
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    private func setAudioSession() {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        try? AVAudioSession.sharedInstance().setActive(true)
        MusicStation.shared.play(type: .main)
    }
    
    private func presentMainViewController() {
        let hasLaunchedOnce = userDefaults.bool(forKey: IdentifierUD.hasLaunchedOnce)
        let settings = getSettingInformation(hasLaunchedOnce)
        let coordinator = SceneCoordinator(window: window!)
        let database = DatabaseManager(Database.database().reference())
        let scene = getFirstScene(hasLaunchedOnce, coordinator, database, settings)
        coordinator.transition(to: scene, using: .root, with: StoryboardType.main, animated: false)
    }
    
    private func getSettingInformation(_ hasLaunchedOnce: Bool) -> SettingInformation {
        let data = try? userDefaults.getStruct(forKey: IdentifierUD.setting, castTo: SettingInformation.self)
        let settings = !hasLaunchedOnce ? SettingInformation.defaultValues() : data ?? SettingInformation.defaultValues()
        return settings
    }
    
    private func getFirstScene(_ hasLaunchedOnce: Bool,
                               _ sceneCoordinator: SceneCoordinator,
                               _ database: DatabaseManager,
                               _ settings: SettingInformation) -> Scene {
        
        switch hasLaunchedOnce {
        
        case true:
            let mainViewModel = MainViewModel(sceneCoordinator: sceneCoordinator, storage: storage, adStorage: adStorage, database: database, settings: settings)
            let mainScene = Scene.main(mainViewModel)
            return mainScene
            
        case false:
            let storyViewModel = StoryViewModel(sceneCoordinator: sceneCoordinator, storage: storage, adStorage: adStorage, database: database, settings: settings)
            let storyScene = Scene.story(storyViewModel)
            return storyScene
            
        }
    }
}
