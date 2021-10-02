import Foundation
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth
import GameKit

final class MainViewModel: CommonViewModel {
    
    private let storage: GameDataManagable & RewardManagable
    private var settingInfo: SettingInformation
    private let userDefaults = UserDefaults.standard
    
    lazy var settingSwitchState = BehaviorRelay<SettingInformation>(value: settingInfo)
    let storageDidSetup = BehaviorRelay<Bool>(value: false)
    private(set) var rewardAvailable = BehaviorRelay<Bool>(value: false)
    
    init(sceneCoordinator: SceneCoordinatorType, storage: GameDataManagable & RewardManagable, settings: SettingInformation) {
        self.settingInfo = settings
        self.storage = storage
        super.init(sceneCoordinator: sceneCoordinator)

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
            let shopViewModel = ShopViewModel(sceneCoordinator: sceneCoordinator,
                                              storage: storage as! (GameMoneyManagable & RewardManagable))
            let shopScene = MainScene.shop(shopViewModel)
            self.sceneCoordinator.transition(to: shopScene, using: .fullScreen, with: StoryboardType.main, animated: true)
            
        case .rankVC:
            let rankViewModel = RankViewModel(sceneCoordinator: sceneCoordinator)
            let rankScene = MainScene.rank(rankViewModel)
            self.sceneCoordinator.transition(to: rankScene, using: .fullScreen, with: StoryboardType.main, animated: true)
            
        case .itemVC:
            let itemViewModel = ItemViewModel(sceneCoordinator: sceneCoordinator,
                                              storage: storage as! (GameItemManagable & GameMoneyManagable))
            let itemScene = MainScene.item(itemViewModel)
            self.sceneCoordinator.transition(to: itemScene, using: .fullScreen, with: StoryboardType.main, animated: true)
            
        case .gameVC:
            let gameUnitManager = GameUnitManager(allKinds: Unit.initialValues())
            let gameViewModel = GameViewModel(sceneCoordinator: sceneCoordinator,
                                              storage: storage as! (HighScoreManagable & GameItemManagable),
                                              gameUnitManager: gameUnitManager)
            let gameScene = GameScene.game(gameViewModel)
            self.sceneCoordinator.transition(to: gameScene, using: .fullScreen, with: StoryboardType.game, animated: true)
            
        case .settingVC:
            let settingScene = GameHelperScene.setting(self)
            self.sceneCoordinator.transition(to: settingScene, using: .overCurrent, with: StoryboardType.main, animated: true)
            
        case .storyVC:
            let storyViewModel = StoryViewModel(sceneCoordinator: sceneCoordinator,
                                                settings: settingInfo,
                                                isFirstTimePlay: false)
            let storyScene = GameHelperScene.story(storyViewModel)
            self.sceneCoordinator.transition(to: storyScene, using: .fullScreen, with: StoryboardType.main, animated: true)
            
        case .howToVC:
            let howToViewModel = HowToPlayViewModel(sceneCoordinator: sceneCoordinator)
            let howToScene = GameHelperScene.howToPlay(howToViewModel)
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
                let scene = MainScene.gameCenter(gcViewController)
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
        let alertScene = AlertScene.alert(AlertMessage.networkLoad)
        sceneCoordinator.transition(to: alertScene,
                                    using: .alert,
                                    with: .main,
                                    animated: true)
    }
}
