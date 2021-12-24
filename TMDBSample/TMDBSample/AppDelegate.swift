import AsyncDisplayKit
import CoreData
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let navigationController: ASDKNavigationController = ASDKNavigationController()
    private let dependencyContainer: Container = Container()
    lazy var coreDataStack = CoreDataStack(modelName: "TMDBSample")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        setupDependencies()
        /// Remove `simulateAuthFlow` and move auth logic into appropriate module
        simulateAuthFlow()
        navigationController.setViewControllers([ListViewController(dependencyContainer)], animated: false)
        return true
    }
}

// MARK: - Private

private extension AppDelegate {
    func setupWindow() {
        if let _ = window { return }
        
        window = UIWindow()
        window?.backgroundColor = .black
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        (UIApplication.shared.delegate as! AppDelegate).window = window
    }
    
    func setupDependencies() {
        dependencyContainer.register(MoviesService.self) { _ in MoviesService() }.inObjectScope(.container)
    }
}

// MARK: - Simulations

extension AppDelegate: TokenManageable {}

private extension AppDelegate {
    /**
     Simulates auth behaviour the result: appropriate user accessToken is received
     */
    func simulateAuthFlow() {
        let token = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlZjVjNzRmYTllZDVkNmYyZjFiN2NlOWI4Mzg4YjVmZCIsInN1YiI6IjYxYzM4MDVlZDA1YTAzMDA1ZjlkNGMyMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0RdwyYhnLIFFaNBgfaz_uaN70WNshMlwCqjqClB29BU"
        do {
            try saveAccessToken(token)
        } catch {
            assertionFailure("Failed to save access token")
        }
    }
}
