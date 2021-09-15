import Foundation
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth
import GameKit

final class MainViewModel: AdViewModel {
    
    private var settingInfo: SettingInformation
    private let userDefaults = UserDefaults.standard
    
    lazy var settingSwitchState = BehaviorRelay<SettingInformation>(value: settingInfo)
    let storageDidSetup = BehaviorRelay<Bool>(value: false)
    private(set) var rewardAvailable = BehaviorRelay<Bool>(value: false)
    
    init(sceneCoordinator: SceneCoordinatorType, storage: StorageType, settings: SettingInformation) {
        self.settingInfo = settings
        super.init(sceneCoordinator: sceneCoordinator, storage: storage)

        bindRewardStates()
        setupAppleGameCenterLogin()
    }

    private func bindRewardStates() {
        storage.availableRewards()
            .subscribe(onNext: { [weak self] items in
                let rewardState = !ShopItem.isAllTaken(items)
                self?.rewardAvailable.accept(rewardState)
            }).disposed(by: rx.disposeBag)
    }
    
    func makeMoveAction(to viewController: ViewControllerType) {
        guard storageDidSetup.value else { return }
        
        switch viewController {
        case .giftVC:
            let shopViewModel = ShopViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage)
            let shopScene = Scene.shop(shopViewModel)
            self.sceneCoordinator.transition(to: shopScene, using: .fullScreen, with: StoryboardType.main, animated: true)
            
        case .rankVC:
            let rankViewModel = RankViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage)
            let rankScene = Scene.rank(rankViewModel)
            self.sceneCoordinator.transition(to: rankScene, using: .fullScreen, with: StoryboardType.main, animated: true)
            
        case .itemVC:
            let itemViewModel = ItemViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage)
            let itemScene = Scene.item(itemViewModel)
            self.sceneCoordinator.transition(to: itemScene, using: .fullScreen, with: StoryboardType.main, animated: true)
            
        case .gameVC:
            let gameUnitManager = GameUnitManager(allKinds: Unit.initialValues())
            let gameViewModel = GameViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, gameUnitManager: gameUnitManager)
            let gameScene = Scene.game(gameViewModel)
            self.sceneCoordinator.transition(to: gameScene, using: .fullScreen, with: StoryboardType.game, animated: true)
            
        case .settingVC:
            let settingScene = Scene.setting(self)
            self.sceneCoordinator.transition(to: settingScene, using: .overCurrent, with: StoryboardType.main, animated: true)
            
        case .storyVC:
            let storyViewModel = StoryViewModel(sceneCoordinator: sceneCoordinator, storage: storage, settings: settingInfo, isFirstTimePlay: false)
            let storyScene = Scene.story(storyViewModel)
            self.sceneCoordinator.transition(to: storyScene, using: .fullScreen, with: StoryboardType.main, animated: true)
            
        case .howToVC:
            let howToViewModel = HowToPlayViewModel(sceneCoordinator: sceneCoordinator, storage: storage)
            let howToScene = Scene.howToPlay(howToViewModel)
            self.sceneCoordinator.transition(to: howToScene, using: .fullScreen, with: StoryboardType.main, animated: true)
        }
    }
    
    func makeCloseAction() {
        sceneCoordinator.close(animated: true)
    }
    
    @discardableResult
    func setupBGMState(_ info: SwithType) -> Completable {
        let subject = PublishSubject<Void>()
        settingInfo.changeState(info)
        settingSwitchState.accept(settingInfo)
        
        do {
            try userDefaults.setStruct(settingInfo, forKey: IdentifierUD.setting)
            if info == .bgm { MusicStation.shared.toggle() }
        } catch {
            subject.onError(UserDefaultsError.cannotSaveSettingData)
        }
        return subject.ignoreElements().asCompletable()
    }
}

// MARK: Login
extension MainViewModel: GKGameCenterControllerDelegate {

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    }
    
    private func setupAppleGameCenterLogin() {
        GKLocalPlayer.local.authenticateHandler = { [unowned self] gcViewController, error in
            if let gcViewController = gcViewController {
                let scene = Scene.gameCenter(gcViewController)
                self.sceneCoordinator.transition(to: scene, using: .fullScreen, with: StoryboardType.main, animated: false)
            } else if let error = error {
                Firebase.Analytics.logEvent("CancelGameCenter", parameters: ["ErrorMessage": "\(error.localizedDescription)"])
                self.load(with: nil)
            } else {
                self.sceneCoordinator.toMain(animated: true)
                
                GameCenterAuthProvider.getCredential { credential, error in
                    
                    if let error = error {
                        Firebase.Analytics.logEvent("AuthError", parameters: ["ErrorMessage": "\(error.localizedDescription)"])
                    }
                    
                    guard let credential = credential else {
                        self.load(with: nil)
                        return
                    }
                    
                    Auth.auth().signIn(with: credential) { [unowned self] user, error in
                        
                        if let error = error {
                            Firebase.Analytics.logEvent("SignInError", parameters: ["ErrorMessage": "\(error.localizedDescription)"])
                            self.load(with: nil)
                        }
                        
                        if let user = user {
                            self.load(with: user.user.uid)
                        }
                    }
                }
            }
        }
    }
}

// MARK: Storage Load
extension MainViewModel {
    private func load(with uuid: String?) {
        guard !self.storageDidSetup.value else { return }
        
        let isFirstLaunched = !userDefaults.bool(forKey: IdentifierUD.hasLaunchedOnce)
        
        storage.initializeData(using: uuid, isFirstLaunched: isFirstLaunched)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] isInitialized in
                self.storageDidSetup.accept(isInitialized)
            }).disposed(by: rx.disposeBag)
        
        markAsLauncedOnce()
        
        if uuid == nil {
            showNetworkAlert()
        }
    }
    
    private func markAsLauncedOnce() {
        userDefaults.setValue(true, forKey: IdentifierUD.hasLaunchedOnce)
    }
    
    private func showNetworkAlert() {
        sceneCoordinator.transition(to: .alert(AlertMessage.networkLoad),
                                    using: .alert,
                                    with: .main,
                                    animated: true)
    }
}
