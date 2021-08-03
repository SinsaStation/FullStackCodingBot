import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import GameKit

final class MainViewModel: AdViewModel {
    
    let firebaseDidLoad = BehaviorRelay<Bool>(value: false)
    let bgmSwitchState = BehaviorRelay<Bool>(value: UserDefaults.standard.bool(forKey: IdentifierUD.bgmState))
    
    private let userDefaults = UserDefaults.standard
    
    override init(sceneCoordinator: SceneCoordinatorType, storage: PersistenceStorageType, adStorage: AdStorageType, database: DatabaseManagerType) {
        
        super.init(sceneCoordinator: sceneCoordinator, storage: storage, adStorage: adStorage, database: database)
        
        setupAppleGameCenterLogin()
        setupFirstLaunchedInfo()
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
    
    func setupBGMState(_ onOff: Bool) {
        UserDefaults.standard.setValue(onOff, forKey: IdentifierUD.bgmState)
        bgmSwitchState.accept(onOff)
    }
    
    private func updateDatabaseInformation(_ info: NetworkDTO) {
        startLoading()
        info.units.forEach { storage.append(unit: $0) }
        storage.raiseMoney(by: info.money)
        storage.updateHighScore(new: info.score)
        adStorage.setNewRewardsIfPossible(with: info.ads)
    }
    
    private func setupFirstLaunchedInfo() {
        if !userDefaults.bool(forKey: IdentifierUD.hasLaunchedOnce) {
            userDefaults.setValue(true, forKey: IdentifierUD.bgmState)
            bgmSwitchState.accept(true)
        }
    }
}

extension MainViewModel: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        print("GameCenterVC Dismissed")
    }
    
    func setupAppleGameCenterLogin() {
        GKLocalPlayer.local.authenticateHandler = { gcViewController, error in
            guard error == nil else { return }
            
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
