import UIKit
import GoogleMobileAds
import Firebase
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var storage: StorageType?
    private let userDefaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        storage = Storage()
        setAdMobs()
        setAudioSession()
        presentMainViewController()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        storage?.save()
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
        let scene = getFirstScene(hasLaunchedOnce, coordinator, settings)
        coordinator.transition(to: scene, using: .root, with: StoryboardType.main, animated: false)
    }
    
    private func getSettingInformation(_ hasLaunchedOnce: Bool) -> SettingInformation {
        let data = try? userDefaults.getStruct(forKey: IdentifierUD.setting, castTo: SettingInformation.self)
        let settings = !hasLaunchedOnce ? SettingInformation.defaultValues() : data ?? SettingInformation.defaultValues()
        return settings
    }
    
    private func getFirstScene(_ hasLaunchedOnce: Bool,
                               _ sceneCoordinator: SceneCoordinator,
                               _ settings: SettingInformation) -> SceneType {
        switch hasLaunchedOnce {
        
        case true:
            let mainViewModel = MainViewModel(sceneCoordinator: sceneCoordinator,
                                              storage: storage! as (RewardManagable & GameDataManagable),
                                              settings: settings)
            let mainScene = MainScene.main(mainViewModel)
            return mainScene
            
        case false:
            let storyViewModel = StoryViewModel(sceneCoordinator: sceneCoordinator, settings: settings)
            let storyScene = GameHelperScene.story(storyViewModel)
            return storyScene
            
        }
    }
}
