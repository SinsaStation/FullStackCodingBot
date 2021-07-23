import UIKit
import GoogleMobileAds
import Firebase
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [kGADSimulatorID]
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        let coordinator = SceneCoordinator(window: window!)
        let storage = ItemStorage()
        let database = DatabaseManager(Database.database().reference())
        let adStorage = AdStorage()
        let mainViewModel = MainViewModel(sceneCoordinator: coordinator, storage: storage, adStorage: adStorage, database: database)
        let mainScene = Scene.main(mainViewModel)
        coordinator.transition(to: mainScene, using: .root, with: StoryboardType.main, animated: false)
        return true
    }
    
    // MARK: - Core Data Stack
    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataStorage")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("\(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("\(nserror), \(nserror.userInfo)")
            }
        }
    }
}
