import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import GameKit

final class MainViewModel: AdViewModel {
    
    private var settingInfo: SettingInformation
    private let userDefaults = UserDefaults.standard
    
    lazy var settingSwitchState = BehaviorRelay<SettingInformation>(value: settingInfo)
    let firebaseDidLoad = BehaviorRelay<Bool>(value: false)
    
    init(sceneCoordinator: SceneCoordinatorType, storage: PersistenceStorageType, adStorage: AdStorageType, database: DatabaseManagerType, setting: SettingInformation) {
        self.settingInfo = setting
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, adStorage: adStorage, database: database)
        
        setupAppleGameCenterLogin()
    }
    
    func makeMoveAction(to viewController: ViewControllerType) {
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
                print(error)
            }, onCompleted: { [unowned self] in
                self.firebaseDidLoad.accept(true)
            }).disposed(by: rx.disposeBag)
    }
    
    func setupBGMState(_ info: SwithType) {
        settingInfo.changeState(info)
        settingSwitchState.accept(settingInfo)
        do {
            try userDefaults.setStruct(settingInfo, forKey: IdentifierUD.setting)
        } catch {
            print(error)
        }
        
    }
    
    private func updateDatabaseInformation(_ info: NetworkDTO) {
        info.units.forEach { storage.append(unit: $0) }
        storage.raiseMoney(by: info.money)
        storage.updateHighScore(new: info.score)
        adStorage.setNewRewardsIfPossible(with: info.ads)
    }
    
    private func observeFirebaseDataLoaded() {
        firebaseDidLoad
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] isLoaded in
                if !isLoaded { self.startLoading() }
            }).disposed(by: rx.disposeBag)
    }
}

extension MainViewModel: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        print("GameCenterVC Dismissed")
    }
    
    func setupAppleGameCenterLogin() {
        GKLocalPlayer.local.authenticateHandler = { gcViewController, error in
            guard error == nil else { return }
            self.observeFirebaseDataLoaded()
            
            if GKLocalPlayer.local.isAuthenticated {
                GameCenterAuthProvider.getCredential { credential, error in
                    guard error == nil else { return }
                    
                    Auth.auth().signIn(with: credential!) { [unowned self] user, error in
                        guard error == nil else { return }
                        
                        if user != nil {
                            getUserInformation()
                            userDefaults.setValue(true, forKey: IdentifierUD.hasLaunchedOnce)
                        }
                    }
                }
            } else if let gcViewController = gcViewController {
                print(gcViewController)
            }
        }
    }
}
