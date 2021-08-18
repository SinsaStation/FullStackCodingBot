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
    
    init(sceneCoordinator: SceneCoordinatorType, storage: PersistenceStorageType, adStorage: AdStorageType, database: DatabaseManagerType, settings: SettingInformation) {
        self.settingInfo = settings
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, adStorage: adStorage, database: database)
        
        setupAppleGameCenterLogin()
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
    
    func startLoading() {
        let loadScene = Scene.load(self)
        self.sceneCoordinator.transition(to: loadScene, using: .overCurrent, with: StoryboardType.main, animated: true)
    }
    
    func makeCloseAction() {
        sceneCoordinator.close(animated: true)
    }
    
    func getUserInformation() {
        database.getFirebaseData()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] data in
                self.updateDatabaseInformation(data)
            }, onError: { error in
                self.networkLoadError(error)
            }, onCompleted: { [unowned self] in
                self.firebaseDidLoad.accept(true)
            }).disposed(by: rx.disposeBag)
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
    
    private func updateDatabaseInformation(_ info: NetworkDTO) {
        info.units.forEach { storage.append(unit: $0) }
        storage.raiseMoney(by: info.money)
        storage.updateHighScore(new: info.score)
        
        adStorage.setNewRewardsIfPossible(with: info.ads)
            .subscribe(onError: { error in
                        Firebase.Analytics.logEvent("RewardsError", parameters: ["ErrorMessage": "\(error)"])})
            .disposed(by: rx.disposeBag)
    }
    
    private func observeFirebaseDataLoaded() {
        firebaseDidLoad
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] isLoaded in
                if !isLoaded { self.startLoading() }
            }).disposed(by: rx.disposeBag)
    }
}

// MARK: Apple Game Center Login
extension MainViewModel: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    }
    
    func setupAppleGameCenterLogin() {
        GKLocalPlayer.local.authenticateHandler = { [unowned self] _, error in
            guard error == nil else {
                self.networkLoadError(error)
                return
            }
            self.observeFirebaseDataLoaded()
            
            if GKLocalPlayer.local.isAuthenticated {
                GameCenterAuthProvider.getCredential { credential, error in
                    guard error == nil else {
                        self.networkLoadError(error)
                        return
                    }
                    
                    Auth.auth().signIn(with: credential!) { [unowned self] user, error in
                        guard error == nil else {
                            self.networkLoadError(error)
                            return
                        }
                        
                        if user != nil {
                            if firebaseDidLoad.value { return }
                            getUserInformation()
                            userDefaults.setValue(true, forKey: IdentifierUD.hasLaunchedOnce)
                        }
                    }
                }
            }
        }
    }
}

// MARK: Error Handling
private extension MainViewModel {
    
    private func networkLoadError(_ error: Error?) {
        let alertScene = Scene.alert(AlertMessage.networkLoad)
        self.sceneCoordinator.transition(to: alertScene, using: .alert, with: StoryboardType.main, animated: true)
        guard let error = error else { return }
        Firebase.Analytics.logEvent("NetworkError", parameters: ["ErrorMessage": "\(error)"])
    }
}
