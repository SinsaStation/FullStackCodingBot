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
    let firebaseDidLoad = BehaviorRelay<Bool>(value: false)
    private(set) var rewardAvailable = BehaviorRelay<Bool>(value: false)
    
    init(sceneCoordinator: SceneCoordinatorType, storage: PersistenceStorageType, adStorage: AdStorageType, database: DatabaseManagerType, settings: SettingInformation) {
        self.settingInfo = settings
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, adStorage: adStorage, database: database)
        
        bindRewardState()
        setupAppleGameCenterLogin()
    }
    
    private func bindRewardState() {
        adStorage.availableItems()
            .subscribe(onNext: { [weak self] items in
                let rewardState = !ShopItem.isAllTaken(items)
                self?.rewardAvailable.accept(rewardState)
            }).disposed(by: rx.disposeBag)
    }
    
    func makeMoveAction(to viewController: ViewControllerType) {
        guard firebaseDidLoad.value else { return }
        
        switch viewController {
        case .giftVC:
            let shopViewModel = ShopViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, adStorage: adStorage, database: database)
            let shopScene = Scene.shop(shopViewModel)
            self.sceneCoordinator.transition(to: shopScene, using: .fullScreen, with: StoryboardType.main, animated: true)
            
        case .rankVC:
            let rankViewModel = RankViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, database: database)
            let rankScene = Scene.rank(rankViewModel)
            self.sceneCoordinator.transition(to: rankScene, using: .fullScreen, with: StoryboardType.main, animated: true)
            
        case .itemVC:
            let itemViewModel = ItemViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, database: database)
            let itemScene = Scene.item(itemViewModel)
            self.sceneCoordinator.transition(to: itemScene, using: .fullScreen, with: StoryboardType.main, animated: true)
            
        case .gameVC:
            let gameUnitManager = GameUnitManager(allKinds: self.storage.itemList())
            let gameViewModel = GameViewModel(sceneCoordinator: self.sceneCoordinator, storage: self.storage, database: database, gameUnitManager: gameUnitManager)
            let gameScene = Scene.game(gameViewModel)
            self.sceneCoordinator.transition(to: gameScene, using: .fullScreen, with: StoryboardType.game, animated: true)
            
        case .settingVC:
            let settingScene = Scene.setting(self)
            self.sceneCoordinator.transition(to: settingScene, using: .overCurrent, with: StoryboardType.main, animated: true)
            
        case .storyVC:
            let storyViewModel = StoryViewModel(sceneCoordinator: sceneCoordinator, storage: storage, adStorage: adStorage, database: database, settings: settingInfo, isFirstTimePlay: false)
            let storyScene = Scene.story(storyViewModel)
            self.sceneCoordinator.transition(to: storyScene, using: .fullScreen, with: StoryboardType.main, animated: true)
            
        case .howToVC:
            let howToViewModel = HowToPlayViewModel(sceneCoordinator: sceneCoordinator, storage: storage, adStorage: adStorage, database: database)
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

// MARK: Login & Load Data
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
                self.loadOffline()
            } else {
                self.sceneCoordinator.toMain(animated: true)
                
                GameCenterAuthProvider.getCredential { credential, error in
                    
                    if let error = error {
                        Firebase.Analytics.logEvent("AuthError", parameters: ["ErrorMessage": "\(error.localizedDescription)"])
                    }
                    
                    guard let credential = credential else {
                        self.loadOffline()
                        return
                    }
                    
                    Auth.auth().signIn(with: credential) { [unowned self] user, error in
                        
                        if let error = error {
                            Firebase.Analytics.logEvent("SignInError", parameters: ["ErrorMessage": "\(error.localizedDescription)"])
                            self.loadOffline()
                        }
                        
                        if let user = user {
                            loadOnline(user.user.uid)
                        }
                    }
                }
            }
        }
    }
    
    private func loadOffline() {
        loadFromCoredata()
        sceneCoordinator.transition(to: .alert(AlertMessage.networkLoad),
                                    using: .alert,
                                    with: .main,
                                    animated: true)
    }
    
    private func loadOnline(_ uuid: String?) {
        if !userDefaults.bool(forKey: IdentifierUD.hasLaunchedOnce) {
            storage.setupInitialData()
        }
        loadFromFirebase(uuid)
    }
    
    private func loadFromCoredata() {
        switch userDefaults.bool(forKey: IdentifierUD.hasLaunchedOnce) {
        case true:
            storage.getCoreDataInfo()
        case false:
            storage.setupInitialData()
        }
        userDefaults.setValue(true, forKey: IdentifierUD.hasLaunchedOnce)
        firebaseDidLoad.accept(true)
    }
    
    private func loadFromFirebase(_ uuid: String?) {
        if firebaseDidLoad.value { return }
        getUserInformation(uuid)
        userDefaults.setValue(true, forKey: IdentifierUD.hasLaunchedOnce)
    }
    
    private func getUserInformation(_ uuid: String?) {
        database.getFirebaseData(uuid!)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] data in
                self.updateDatabaseInformation(data)
                self.updateAdInformation(data)
            }, onError: { _ in
                self.loadFromCoredata()
            }, onCompleted: { [unowned self] in
                self.firebaseDidLoad.accept(true)
            }).disposed(by: rx.disposeBag)
    }
    
    private func updateDatabaseInformation(_ info: NetworkDTO) {
        let firebaseUpdate = info.date
        let coredataUpdate = storage.lastUpdated()
        
        guard firebaseUpdate > coredataUpdate else {
            loadFromCoredata()
            return
        }
        
        storage.update(units: info.units)
        storage.raiseMoney(by: info.money)
        storage.updateHighScore(new: info.score)
    }
    
    private func updateAdInformation(_ info: NetworkDTO) {
        adStorage.setNewRewardsIfPossible(with: info.ads)
            .subscribe(onError: { error in
                        Firebase.Analytics.logEvent("RewardsError", parameters: ["ErrorMessage": "\(error)"])})
            .disposed(by: rx.disposeBag)
    }
}
